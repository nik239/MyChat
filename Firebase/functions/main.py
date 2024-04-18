# Welcome to Cloud Functions for Firebase for Python!
# To get started, simply uncomment the below code or create your own.
# Deploy with `firebase deploy`

from typing import Any
from firebase_admin import initialize_app, firestore, auth
from firebase_functions import https_fn

app = initialize_app()

@https_fn.on_call()
def set_display_name(req: https_fn.CallableRequest) -> Any:
    """Sets the user's name in chats and users collections"""
    if not req.auth: 
        raise https_fn.HttpsError(code = "unauthenticated",
                                  message = "User unauthenticated.")
    
    try:
        uid = req.auth.uid
        user = auth.get_user(uid)
        old_name = user.display_name
        new_name = req.data["new_name"]
    except KeyError: 
        raise https_fn.HttpsError(code = "invalid-argument",
                                  message = "New name not provided.")
    
    user = auth.update_user(uid, display_name = new_name)
    update_user_table(old_name, new_name, uid)

    if not old_name:
      return

    update_chats(old_name, new_name)


@https_fn.on_call() 
def create_chat(req: https_fn.CallableRequest) -> Any: 
    """Fetches uids by username and creates a new chat"""
    if not req.auth: 
        raise https_fn.HttpsError(code = "unauthenticated",
                                  message = "User unauthenticated.")
    
    try: 
        uid = req.auth.uid
        name = req.data["name"]
        members = req.data["members"]
    
    except KeyError: 
        raise https_fn.HttpsError(code = "invalid-argument",
                                  message = "Members not provided.")
    

    db = firestore.client()
    user_table_doc = db.collection("user_table").document("user_table").get()
    user_table = user_table_doc.to_dict()["user_table"]

    uids = [user_table[member] for member in members]
    uids.append(uid)

    if name == "": 
        name = ", ".join(members)

    db.collection("chats").document().set({"members":members,
                                            "name": name,
                                            "uids": uids})


def update_user_table(old, new, uid):
    """Updates name in user-table, then updates all_users. 
    If new name is taken throws."""
    db = firestore.client()
    user_table_ref = db.collection("user_table").document("user_table")
    users_ref = db.collection("users").document("all_users")
    user_table_doc = user_table_ref.get()

    #remove this before deploying
    if not user_table_doc.exists: 
        user_table_ref.set({"user_table":{new: uid}})
        users_ref.set({"all_users": [new]})
        return

    user_table = user_table_doc.to_dict()['user_table']

    if new in user_table:
        raise https_fn.HttpsError(code = "already-exists",
                                  message = "Username is taken.")
    else: 
        if old:
            del user_table[old]
        user_table[new] = uid
        user_table_ref.update({'user_table': user_table})
        users_ref.update({'all_users': list(user_table.keys())})


def update_chats(old, new):
    """Updates name in all chats to which the user belongs"""
    db = firestore.client()
    if not old:
        return

    query = db.collection("chats").where("members", "array_contains", old)
    documents = query.stream() 

    for document in documents:
        doc_ref = db.collection("chats").document(document.id)
        doc_data = document.to_dict()
        members = doc_data['members']
        members = [new if member == old else member for member in members]
        doc_ref.update({'members': members})


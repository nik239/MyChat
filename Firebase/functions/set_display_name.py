from typing import Any

# Dependencies for callable functions.
from firebase_functions import https_fn, options

# The Firebase Admin SDK to access Cloud Firestore.
from firebase_admin import initialize_app, firestore, auth
import google.cloud.firestore

@https_fn.on_call()
def set_display_name(req: https_fn.CallableRequest) -> Any:
    """Sets the user's name in chats and users collections"""
    if not req.auth: 
        raise https_fn.HttpsError(code = "unauthenticated",
                                  message = "User unauthenticated")
    
    try:
        uid = req.auth.uid
        user = auth.get_user(uid)
        old_name = user.display_name
        new_name = req.data["new_name"]
        print(new_name)
    except KeyError: 
        raise https_fn.HttpsError(code = "invalid-argument",
                                  message = "new_name not provided")
    
    user = auth.update_user(uid, display_name = new_name)
    
    if not old_name:
      return
    else:
      set_users_collection(old_name, new_name)
      update_chats(old_name, new_name)


def set_users_collection(old, new):
    """Updates name in users collection. If new name is taken throws."""
    db = firestore.client()
    doc_ref = db.collection("users").document("all_users")
    users_doc = doc_ref.get()

    print(users_doc)

    #should move all_users init to server init
    if not users_doc.exists: 
        doc_ref.set({"all_users": [new]})
        return

    all_users = users_doc.to_dict()['all_users']

    if new in all_users:
        raise https_fn.HttpsError(code = "invalid-argument",
                                  message = "Name is taken")
    else: 
        all_users.dicard(old)
        all_users.add(new)
        doc_ref.update({'all_users': all_users})

        

def update_chats(old, new):
    """Updates name in all chats to which the user belongs"""
    db = firestore.client()
    if not old:
        return

    query = db.collection("chats").where("members", "array_contains", old)
    documents = query.stream() 

    for document in documents:
        print("got some docs")
        doc_ref = db.collection("chats").document(document.id)
        doc_data = document.to_dict()
        members = doc_data['members']
        members = [new if member == old else member for member in members]
        doc_ref.update({'members': members})
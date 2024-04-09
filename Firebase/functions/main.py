# Welcome to Cloud Functions for Firebase for Python!
# To get started, simply uncomment the below code or create your own.
# Deploy with `firebase deploy`

from typing import Any

# Dependencies for callable functions.
from firebase_functions import https_fn, options

# The Firebase Admin SDK to access Cloud Firestore.
from firebase_admin import initialize_app, firestore, auth
import google.cloud.firestore

app = initialize_app()
db = firestore.client()

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
    except KeyError: 
        raise https_fn.HttpsError(code = "invalid-argument",
                                  message = "new_name not provided")
    
    set_users_collection(old_name, new_name)
    update_chats(old_name, new_name)


def set_users_collection(old, new):
    """Updates name in users collection. If new name is taken throws."""
    doc_ref = db.collection("users").where("name", "equals", new)

    if doc_ref.get().exists:
        raise https_fn.HttpsError(code = "already-exists",
                                  message = "Username is taken")
    elif old:
        db.collection("users").where("name", "equals", old).set({"name": new})
    else: 
        db.collection("users").document({"name": new})

        

def update_chats(old, new):
    """Updates name in all chats to which the user belongs"""
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






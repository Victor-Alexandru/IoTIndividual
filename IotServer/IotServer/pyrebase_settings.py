import pyrebase

config = {
    "apiKey": "AIzaSyColiqC2V3r_PM1pu11OKoUS7f1Ky8HDOw",
    "authDomain": "police-29.firebaseapp.com",
    "databaseURL": "https://police-29.firebaseio.com",
    "projectId": "police-29",
    "storageBucket": "police-29.appspot.com",
    "messagingSenderId": "220810485790",
    "appId": "1:220810485790:web:d41a665a5c9f4870cbce0f",
    "measurementId": "G-PZEP24K4ZV",
    "serviceAccount": "ServiceKey.json"
}

# initialize app with config
firebase = pyrebase.initialize_app(config)

# authenticate a user
auth = firebase.auth()
user = auth.sign_in_with_email_and_password("victor21cuciureanu@gmail.com", "firebasepassword")

db = firebase.database()
firebase_storage = firebase.storage()

# import firebase_admin
# from firebase_admin import credentials, storage
#
# if (not len(firebase_admin._apps)):
#     cred = credentials.Certificate('./ServiceKey.json')
#     default_app = firebase_admin.initialize_app(cred, {
#         'storageBucket': 'police-29.appspot.com'
#     })
#
# firebase_storage = storage.bucket('police29')

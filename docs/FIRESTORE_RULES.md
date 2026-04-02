# Firestore Security Rules

## How to Deploy
1. Go to https://console.firebase.google.com
2. Select the HMS project
3. Go to Firestore Database → Rules tab
4. Copy the contents of `firestore.rules` from the project root
5. Paste into the rules editor and click "Publish"

## Rule Summary
- All reads: require authentication
- Creates/Updates: any admin (Super Admin or Admin)
- Deletes: only Super Admin
- Activity Logs: immutable — create only, no update or delete by anyone
- App Config: only Super Admin can modify
- Users: Super Admin manages all, regular users can only update their own displayName
- Notifications: any user can create/read/update, nobody can delete
- Everything else: denied by default

## When to Update
- Adding a new Firestore collection → add rules here
- Changing the role system → update helper functions
- Always test in Firebase Console Rules Playground before publishing

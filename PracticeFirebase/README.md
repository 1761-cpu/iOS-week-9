# Firebase iOS Codelab: FriendlyChat Implementation

Hi Ms. Phượng, my name is Võ Châu Anh. This document outlines the successful completion of the Firebase iOS Codelab (FriendlyChat) for the project `iOS-Week9-Firebase` of Practice Firebase this week 9.

## Project Setup

The Firebase project was successfully initialized. The project dashboard confirms the active status of the `iOS-Week9-Firebase` project.

<img src="https://github.com/user-attachments/assets/0e3c655e-a572-4411-8c9c-9cb287a07fbc" width="500" />

The configuration file `GoogleService-Info.plist` was successfully downloaded and verified to match the project ID `ios-week9-firebase`.

<img src="https://github.com/user-attachments/assets/3d659c2f-bd01-40cd-a673-8d2a140eced9" width="700" />

## Implement `sendMessage`

The text messaging functionality was successfully implemented. A sample message ("Hello") was added directly via the Firebase Console to test the data flow.

<img src="https://github.com/user-attachments/assets/a0da7aa8-609d-4342-a95b-cebb546ebbdf" width="400" />

The UI correctly reflected the new message on the iOS Simulator.

<img src="https://github.com/user-attachments/assets/31cedafd-7911-4aa8-8cb2-8a609ed89efb" width="350" />

## Image Messaging Testing & Workaround

The image messaging feature was tested by selecting an image from the device's photo library using the `PhotosPicker`.

<img src="https://github.com/user-attachments/assets/51ae33bc-a391-4e8f-af34-c7398e13aef3" width="350" />

### ⚠️ Workaround for Firebase Cloud Storage Activation Limitation

During the implementation of image messaging, a limitation was encountered regarding Firebase Cloud Storage.

*   **Issue:** Firebase Cloud Storage required upgrading the project from the free Spark plan to the pay-as-you-go Blaze plan to initialize a storage bucket. Because no billing account was linked to this development project, Cloud Storage could not be activated.
*   **Technical impact:** When selecting an image via `PhotosPicker` and attempting to upload binary data (`putDataAsync`) and retrieve a download URL (`downloadURL()`), the SDK threw an `Object images/<uid>/<file>.jpg does not exist` error, preventing image messages from being sent.
*   **Workaround:** The `uploadAndSendImage(data:)` function in `Views/FooterView.swift` was modified to bypass direct file uploads to Firebase Cloud Storage. Instead, it passes a static, publicly accessible HTTPS image URL (`https://picsum.photos/400`) to `viewModel.sendMessage(text: nil, imageUrl:)`.
*   **Verification:** The application successfully stored the image URL message record in Cloud Firestore and rendered the image in the chat UI via `FriendlyMessageImageView` (using `URLSession`) without triggering storage errors.

Below is the updated code for the `uploadAndSendImage` function:

<img src="https://github.com/user-attachments/assets/c8b377b5-9bf5-4ed6-948b-e27d59b358b4" width="700" />

**Final Result**

The screenshot below demonstrates the successful execution of the workaround. The image message (fetched from the static URL) is displayed in the chat interface.

<img src="https://github.com/user-attachments/assets/4544279b-d0cd-45f9-a18e-6a0c367be751" width="350" />

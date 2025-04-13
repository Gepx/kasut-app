# Auth Feature Implementation Plan

This document outlines the plan for implementing the Authentication feature, including Profile (logged-in/out), Login, and Register screens, based on the provided designs and existing project structure.

## 1. File Structure Setup

-   Create a new feature directory: `lib/features/auth/`
-   Inside `lib/features/auth/`, create subdirectories:
    -   `screens/`: To hold the screen widgets.
    -   `widgets/`: For any reusable widgets specific to authentication (e.g., custom buttons, text fields).
-   Create the following files:
    -   `lib/features/auth/screens/profile_screen.dart`
    -   `lib/features/auth/screens/login_screen.dart`
    -   `lib/features/auth/screens/register_screen.dart`
    -   Potentially `lib/features/auth/widgets/auth_button.dart`, `lib/features/auth/widgets/auth_textfield.dart` if common styling is identified.

## 2. Implement Logged-Out Profile Screen (`profile_screen.dart`)

-   **Widget:** `StatefulWidget` (to manage logged-in/out state).
-   **State:** Display this UI when the user is not logged in.
-   **Scaffold:** Use the AppBar provided by `main.dart` (`_CustomAppBar(title: 'Profile')`).
-   **Layout:** `Column` (centered). Add padding.
-   **Avatar:** `CircleAvatar` (stacked grey/dark grey circles).
-   **Text:** "Hi, Fam!" (bold) and description below (centered). Match font sizes/colors.
-   **Buttons:** `Row` with two buttons:
    -   "Login": `OutlinedButton` style (white bg, black text/border, rounded).
    -   "Register": `ElevatedButton` style (black bg, white text, rounded).
-   **Version Text:** "Version 5.0.13" (small, grey).
-   **Responsiveness:** Centered column should adapt well. Test portrait/landscape.

## 3. Implement Login Screen (`login_screen.dart`)

-   **Widget:** `StatelessWidget` or `StatefulWidget`.
-   **Scaffold:** Use a local `Scaffold`.
-   **AppBar:** Custom `AppBar` (white bg, black back arrow, black title "Login", elevation 0).
-   **Layout:** `SingleChildScrollView` -> `Padding` -> `Column`.
-   **Fields:** `TextField` for "Email", "Password" (rounded grey border, hint text, labels above, password visibility toggle).
-   **Forgot Password:** `TextButton`/"InkWell" (aligned right, teal/green text).
-   **Separator:** `Row` with `Expanded` `Divider`s and "Or continue with" `Text`.
-   **Social Buttons:** `Column` of `OutlinedButton`s (Apple, Google, Facebook icons + text, rounded border, white bg, black text/icons).
-   **Login Button:** `ElevatedButton` (disabled grey style initially) + Fingerprint `IconButton` in a `Row`.
-   **Register Link:** `Row` with `Text` ("Don't have an account?") and `TextButton` ("Register Here", teal/green).
-   **Responsiveness:** `SingleChildScrollView` for overflow. Ensure padding/spacing works on different sizes. Test portrait/landscape.

## 4. Implement Register Screen (`register_screen.dart`)

-   **Widget:** `StatelessWidget` or `StatefulWidget`.
-   **Scaffold:** Use a local `Scaffold`.
-   **AppBar:** Custom `AppBar` (white bg, black back arrow, black title "Register", elevation 0).
-   **Layout:** `SingleChildScrollView` -> `Padding` -> `Column`.
-   **Fields:**
    -   Email `TextField`.
    -   Mobile Number: `Row` (Country code dropdown +62/flag + `Expanded` phone number `TextField`).
    -   Password `TextField` (with toggle).
    -   Password Confirmation `TextField` (with toggle).
-   **Terms:** `Row` (`Checkbox` + `RichText`/`Text` with link for "I agree to Terms...").
-   **Register Button:** `ElevatedButton` (disabled grey style initially).
-   **Login Link:** `Row` with `Text` ("Already have an account?") and `TextButton` ("Login here", teal/green).
-   **Responsiveness:** Ensure fields/buttons adapt. Test portrait/landscape.

## 5. Implement Logged-In Profile Screen (`profile_screen.dart`)

-   **Widget:** Same `StatefulWidget` as logged-out state.
-   **State:** Display this UI when the user *is* logged in (check auth state).
-   **Layout:** `Column`.
-   **User Header:** `Row` (`CircleAvatar` with user icon + `Column` with username/email `Text`).
-   **Credit Cards:** `Row` of two `Expanded` `Card`s ("Kick Credit", "Seller Credit") + separate `Card` below ("Kick Points"). Each card: `Column` (Icon + Label `Text` + Value `Text`). Style with rounded corners/shadow.
-   **Menu List:** `ListView`/`Column` of `ListTile`s/custom rows (Icon + Label `Text` for "Buying", "Selling", etc.). Add dividers.
-   **Responsiveness:** Ensure layout, especially cards row, adapts. Test portrait/landscape.

## 6. Integration & Navigation

-   **`main.dart`:**
    -   Import `profile_screen.dart`.
    -   Update `_bottomNavScreens` entry for 'Profile' (index 4) to use `body: (context) => const ProfileScreen()`.
-   **Navigation Logic:**
    -   `ProfileScreen` (Out) -> "Login" -> `LoginScreen`
    -   `ProfileScreen` (Out) -> "Register" -> `RegisterScreen`
    -   `LoginScreen` -> "Register Here" -> `RegisterScreen`
    -   `RegisterScreen` -> "Login here" -> `LoginScreen`
    -   `LoginScreen`/`RegisterScreen` -> Back Button -> `ProfileScreen` (Out)
    -   Successful Auth -> Update `ProfileScreen` state to show Logged-In view.

## Mermaid Diagram

```mermaid
graph TD
    A[main.dart / MainScreen] -- Selects Profile Tab --> P{ProfileScreen};

    subgraph Auth Feature (lib/features/auth)
        P -- State: Logged Out --> P_Out(UI: Logged Out View);
        P -- State: Logged In --> P_In(UI: Logged In View);

        P_Out -- Taps 'Login' Button --> L(LoginScreen);
        P_Out -- Taps 'Register' Button --> R(RegisterScreen);

        L -- Taps 'Register Here' --> R;
        L -- Taps Back Button --> P_Out;
        L -- Successful Login --> P_In; // Auth Logic

        R -- Taps 'Login here' --> L;
        R -- Taps Back Button --> P_Out;
        R -- Successful Registration --> P_In; // Auth Logic
    end

    style P fill:#f9f,stroke:#333,stroke-width:2px
    style L fill:#ccf,stroke:#333,stroke-width:2px
    style R fill:#ccf,stroke:#333,stroke-width:2px
    style P_In fill:#cfc,stroke:#333,stroke-width:2px
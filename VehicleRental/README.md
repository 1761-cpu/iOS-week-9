# Vehicle Rental Management System

Hello Ms. Phượng, my name is Võ Châu Anh. Below is screenshots of outputs examining some features of how is this practice Vehicle Rental Management System working.

---

## Example Test Scenarios

### 1. Initialization & Vehicle Management (FR1)
**Action:** Run the program. The system initializes the mock data. Choose `1` (Vehicle Management) -> `1` (List all vehicles).

*Note: Vehicles `V-1` and `V-2` are automatically marked as **Defective** to test the error handling.*

**Result:**

<img width="972" height="887" alt="Screenshot 2026-11-26 at 16 42 06" src="https://github.com/user-attachments/assets/f44c6faa-8ada-480c-b86b-a8aba19cb2a4" />

### 2. Customer Registration & History (FR2)
**Action:** Choose `2` (Customer Management) -> `2` (Register new customer).
*   Enter Name: `Jane Doe`
*   Enter Phone: `0987654321`
*   Enter Email: `jane@example.com`

**Result:**

<img width="409" height="425" alt="Screenshot 2026-11-26 at 16 43 22" src="https://github.com/user-attachments/assets/d46a8326-1962-4038-ab6a-d55837a8f73f" />

**Action:** Choose `4` (View customer rental history) -> Enter ID: `C21`.

*(Since it's a new customer, the history is empty).*

<img width="398" height="249" alt="Screenshot 2026-11-26 at 16 45 06" src="https://github.com/user-attachments/assets/dfc6dbfc-6e3c-4679-8371-bccb032c6ebb" />

### 3. Rental Operations & Error Handling (FR3, FR4)
**Action:** Choose `3` (Rental Operations) -> `1` (Rent a vehicle).
*   Enter Vehicle ID: `V-1` (This vehicle is Defective).
*   Enter Customer ID: `C21`
*   Enter Days: `3`

**Result:**

<img width="410" height="246" alt="Screenshot 2026-11-26 at 16 46 05" src="https://github.com/user-attachments/assets/ed823b06-9242-4b69-b792-39ec302bfb91" />

**Action:** Try renting an available vehicle.
*   Enter Vehicle ID: `V-3` (Available Motorcycle).
*   Enter Customer ID: `C21`
*   Enter Days: `2`

**Result:**

<img width="501" height="256" alt="Screenshot 2026-11-26 at 16 47 07" src="https://github.com/user-attachments/assets/b211b813-cc03-46a1-8d30-92438087252e" />

*(Note: The cost is automatically calculated based on the vehicle type and engine CC using **Polymorphism**).*

### 4. Return Vehicle
**Action:** Choose `3` (Rental Operations) -> `2` (Return a vehicle).
*   Enter Rental ID: `R-101` (The ID generated from the previous step).

**Result:**

<img width="391" height="214" alt="Screenshot 2026-11-26 at 16 48 54" src="https://github.com/user-attachments/assets/6b605521-6ba6-48b7-be81-f5f23f5d0c4e" />

### 5. Statistics: Available Vehicles by Date (FR5)
**Action:** Choose `4` (Statistics & Reports) -> `1` (Available vehicles on a specific date).

*   Enter Date: `23/11/2026`

**Result:**

<img width="900" height="558" alt="Screenshot 2026-11-26 at 17 01 27" src="https://github.com/user-attachments/assets/40bd0f02-0aec-4282-9d7c-b8c9e16c6b4e" />

### 6. Statistics: Revenue by Month (FR5)
**Action:** Choose `4` (Statistics & Reports) -> `3` (Revenue by month).
*   Enter Month: `11`
*   Enter Year: `2026`

**Result:**

<img width="389" height="527" alt="Screenshot 2026-11-26 at 16 50 12" src="https://github.com/user-attachments/assets/1c0e2018-5e2d-44ab-ae10-c9171f94a18a" />

### 7. Statistics: Daily Vehicle Status
**Action:** Choose `4` (Statistics & Reports) -> `4` (Daily status of all vehicles).
*   Enter Date: `23/11/2026`

**Result:**

<img width="425" height="592" alt="Screenshot 2026-11-26 at 16 51 03" src="https://github.com/user-attachments/assets/ed078b04-a0ad-48c1-a588-8bf4b6a53219" />

*(This provides a full snapshot of the fleet on any given day, proving that `VehicleStatus` and `Rental Dates` are working in perfect sync).*

### 8. Exit
**Action:** Choose `0` to exit the system.

<img width="392" height="368" alt="Screenshot 2026-11-26 at 16 51 36" src="https://github.com/user-attachments/assets/a69ee54a-8e4a-4893-86b3-c2ee1ee377f1" />

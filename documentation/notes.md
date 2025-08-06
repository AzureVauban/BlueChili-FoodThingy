# MVP Notes
1. Add an Item to Pantry  
--------------------------
As a user,  
I want to add food items to my pantry list,  
So that I can keep track of what I have at home.

## Acceptance Criteria:
- There is a simple form with a name field and quantity field.
- Tapping "Add" appends the item to a list.
- The list updates immediately on the screen.


## 2. Delete Item from Pantry  
----------------------------
As a user,  
I want to delete items from my pantry list,  
So that I can remove things I’ve used up.

✅ Acceptance Criteria:
- Each item has a delete button or swipe-to-delete.
- Tapping delete removes the item from the list.
- The UI updates instantly after deletion.


## 3. Save Pantry Locally  
------------------------
As a user,  
I want to save my pantry list even after I close the app,  
So that I don’t lose my inventory.

✅ Acceptance Criteria:
- The app uses `UserDefaults` or `Codable` + local file storage.
- On app launch, it loads saved pantry items.
- Newly added/deleted items are persisted immediately.


## Current Troubles:

- Unable to Resolve image being applied to Detail View Controller
- Unable to implement recipes fetched from [Spooncular](https://spoonacular.com/food-api) 
# Ruby on Rails soft_delete and restore coding test

### Follow the steps below to clone the respository, create the database, run the RSpec tests, and run the dev server to see implementation in the app.

### I will also explain my code below the cloning instructions
#### Ruby version 3.2.2
#### Rails version 7.1.2

**Clone the Repository:**
```bash
git clone https://github.com/chasetmartin/RoR_softDelete.git

cd RoR_softDelete
```
**Install the Dependencies**
```bash
bundle install
```
**Setup and Seed the SQLite3 Database**
```bash
rails db:setup
```
**Run all three RSpec test files that test soft_delete, restore, and the active scope**
```bash
bundle exec rspec -f documentation
```
**Run the Puma server to see the Item and its methods implemented**
```bash
rails server
```
**Navigate to localhost:3000 in your web browser**



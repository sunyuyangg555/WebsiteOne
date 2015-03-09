Feature: Create and maintain projects
  As a member of AgileVentures
  So that I can participate in AgileVentures activities
  I would like to add a new project

  Background:
    Given the following projects exist:
      | title         | description             | pitch       | status   | github_url                                  | pivotaltracker_url                               |
      | hello world   | greetings earthlings    |             | active   | https://github.com/AgileVentures/WebsiteOne | https://www.pivotaltracker.com/s/projects/742821 |
      | hello mars    | greetings aliens        |             | inactive |                                             |                                                  |
      | hello jupiter | greetings jupiter folks |             | active   |                                             |                                                  |
      | hello mercury | greetings mercury folks |             | inactive |                                             |                                                  |
      | hello saturn  | greetings saturn folks  | My pitch... | active   |                                             |                                                  |
      | hello sun     | greetings sun folks     |             | active   |                                             |                                                  |
    And there are no videos

#  Scenarios for Index page

  Scenario: List of projects in table layout
    Given  I am on the "home" page
    When I follow "Projects" within the navbar
    Then I should see "List of Projects"
    Then I should see:
      | Text   |
      | Create |
      | Status |

  Scenario: Columns in projects table
    When I go to the "projects" page
    Then I should see "List of Projects" table


  Scenario: See a list of current projects
    Given  I am on the "home" page
    When I follow "Projects" within the navbar
    Then I should see:
      | Text                    |
      | hello jupiter           |
      | greetings jupiter folks |
      | ACTIVE                  |
      | hello mars              |
      | greetings aliens        |
      | INACTIVE                |

  @github_query
  Scenario: See total github commit count for projects
    Given  I am on the "home" page
    And I fetch the GitHub contribution statistics
    When I follow "Projects" within the navbar
    And I go to the next page
    Then I should see:
      | Text                    |
      | hello world             |
      | ACTIVE                  |
      | 2795                    |

  Scenario: Show New Project button if user is logged in
    When I am logged in
    And I am on the "projects" page
    Then I should see the very stylish "New Project" button

  Scenario: Do not show New Project button if user is not logged in
    Given I am not logged in
    When I am on the "projects" page
    Then I should not see the very stylish "New Project" button

  Scenario: Alphabetically display pagination in "Our Projects" page
    Given I am on the "home" page
    When I follow "Projects" within the navbar
    Then I should see:
      | greetings aliens        |
      | greetings jupiter folks |
      | greetings mercury folks |
      | greetings saturn folks  |
      | greetings sun folks     |
    And I should not see "greetings earthlings"
    When I go to the next page
    Then I should not see:
      | greetings aliens        |
      | greetings jupiter folks |
      | greetings mercury folks |
      | greetings saturn folks  |
      | greetings sun folks     |
    And I should see "greetings earthlings"

#  Scenarios for NEW page

  Scenario: Creating a new project
    Given I am logged in
    And I am on the "projects" page
    When I click the very stylish "New Project" button
    Then I should see "Creating a new Project"
    And I should see a form with:
      | Field               |
      | Title               |
      | Description         |
      | Status              |
      | GitHub link         |
      | PivotalTracker link |

  Scenario: Saving a new project: success
    Given I am logged in
    And I am on the "Projects" page
    When I click the very stylish "New Project" button
    When I fill in:
      | Field               | Text                                            |
      | Title               | Title New                                       |
      | Description         | Description New                                 |
      | GitHub link         | http://www.github.com/abc                       |
      | PivotalTracker link | http://www.pivotaltracker.com/s/projects/982890 |

    And I select "Status" to "Active"
    And I click the "Submit" button
    Then I should be on the "Show" page for project "Title New"
    And I should see "Project was successfully created."
    And I should see:
      | Text            |
      | Title New       |
      | Description New |
      | ACTIVE          |
    And I should see a link to "Title New" on github
    And I should see a link to "Title New" on Pivotal Tracker


  Scenario: Saving a new project: failure
    Given I am logged in
    And I am on the "projects" page
    And I click the very stylish "New Project" button
    When I fill in "Title" with ""
    And I click the "Submit" button
    Then I should see "Project was not saved. Please check the input."

# Scenarios for SHOW page
# Refactor this step

  Scenario: opens "Show" page with projects details
    Given I am logged in
    And I am on the "Projects" page
    When I click "hello saturn" within the List of Projects
    Then I should see:
      | Text                         |
      | hello saturn                 |
      | greetings saturn folks       |
      | My pitch...                  |
      | ACTIVE                       |
      | not linked to GitHub         |
      | not linked to PivotalTracker |
    And I should see "Created"

  Scenario: Edit page has a return link
    Given I am logged in
    And I am on the "Edit" page for projects "hello mars"
    When I click "Back"
    Then I should be on the "Show" page for project "hello mars"

  Scenario: Updating a project: success
    Given I am logged in
    And I am on the "Edit" page for project "hello mars"
    And I fill in "Description" with "Hello, Uranus!"
    And I fill in "GitHub link" with "https://github.com/google/instant-hangouts"
    And I fill in "PivotalTracker link" with "https://www.pivotaltracker.com/s/projects/853345"
    And I click the "Submit" button
    Then I should be on the "Show" page for project "hello mars"
    And I should see a flash "Project was successfully updated."
    And I should see "Hello, Uranus!"
    And I should see a link to "hello mars" on github
    And I should see a link to "hello mars" on Pivotal Tracker

  Scenario: Saving a project: failure
    Given I am logged in
    And I am on the "Edit" page for project "hello mars"
    When I fill in "Title" with ""
    And I click the "Submit" button
    Then I should see "Project was not updated."

  Scenario: Launching Mercury editor 
    Given I am logged in
    And I am on the "Show" page for project "hello mars"
    And I click the "Join Project" button
    And I click "Project Actions"
    And I click "Edit Project Pitch"
    Then I should be in the Mercury Editor

  @javascript
  Scenario: Editing Pitch content with Mercury Editor
    Given I am logged in
    And I am on the "Show" page for project "hello mars"
    And I click the "Join Project" button
    And I am using the Mercury Editor to edit project "hello mars"
    When I fill in the editable field "Pitch" for "project" with "This is my exciting marketing content"
    Then show me the page
    And I click "Save" within Mercury Editor toolbar
    And I should be on the "Show" page for project "hello mars"
    Then I should see a flash "The project has been successfully updated."
    And I should see "This is my exciting marketing content"

  Scenario: The Mercury Editor cannot be accessed by non-logged in users
    Given I am on the "Show" page for project "hello mars"
    Then I should not see "Edit Pitch"
    And I try to use the Mercury Editor to edit project "hello mars"
    Then I should see "You do not have the right privileges to complete action."

  Scenario: Update GitHub url if valid
    Given I am logged in
    And I am on the "Edit" page for project "hello mars"
    And I fill in "GitHub link" with "https://github.com/google/instant-hangouts"
    And I click the "Submit" button
    Then I should be on the "Show" page for project "hello mars"
    And I should see a link to "hello mars" on github

  Scenario: Update Pivotal Tracker url if valid
    Given I am logged in
    And I am on the "Edit" page for project "hello mars"
    And I fill in "PivotalTracker link" with "https://www.pivotaltracker.com/s/projects/853345"
    And I click the "Submit" button
    Then I should be on the "Show" page for project "hello mars"
    And I should see a link to "hello mars" on Pivotal Tracker

  Scenario: Reject GitHub url update if invalid
    Given I am logged in
    And I am on the "Edit" page for project "hello mars"
    And I fill in "GitHub link" with "https:/github.com/google/instant-hangouts"
    And I click the "Submit" button
    Then I should see "Project was not updated."

  Scenario: Reject PivotalTracker url update if invalid
    Given I am logged in
    And I am on the "Edit" page for project "hello mars"
    And I fill in "PivotalTracker link" with "https://www.youtube.com/"
    And I click the "Submit" button
    Then I should see "Project was not updated."

  Scenario: Project show page renders a list of members
    Given The project "hello world" has 10 members
    And I am on the "Show" page for project "hello world"
    Then I should see "Members (10)"
    But I should see 5 member avatars

  Scenario: Project show page has links to github and Pivotal Tracker
    Given I am on the "Show" page for project "hello world"
    And I should see a link to "hello world" on github
    And I should see a link to "hello world" on Pivotal Tracker

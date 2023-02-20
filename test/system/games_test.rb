require "application_system_test_case"

class GamesTest < ApplicationSystemTestCase
  test "Going to /new gives us a new random grid to play with" do
    visit new_url
    assert test: "New game"
    assert_selector ".letter", count: 10
  end

  test "Add a word and return the word is not in the grid" do
    visit new_url
    assert test: "Insert a word not in the grid"
    fill_in "word", with: "dedefrefegtrgrt"
    click_on "Play"
    assert_text "can't be built out"
  end
end

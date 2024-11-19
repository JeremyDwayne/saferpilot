require "application_system_test_case"

class FlightsTest < ApplicationSystemTestCase
  setup do
    @flight = flights(:one)
  end

  test "visiting the index" do
    visit flights_url
    assert_selector "h1", text: "Flights"
  end

  test "should create flight" do
    visit flights_url
    click_on "New flight"

    check "Completed" if @flight.completed
    fill_in "Scheduled at", with: @flight.scheduled_at
    fill_in "Total hours", with: @flight.total_hours
    fill_in "User", with: @flight.user_id
    click_on "Create Flight"

    assert_text "Flight was successfully created"
    click_on "Back"
  end

  test "should update Flight" do
    visit flight_url(@flight)
    click_on "Edit this flight", match: :first

    check "Completed" if @flight.completed
    fill_in "Scheduled at", with: @flight.scheduled_at.to_s
    fill_in "Total hours", with: @flight.total_hours
    fill_in "User", with: @flight.user_id
    click_on "Update Flight"

    assert_text "Flight was successfully updated"
    click_on "Back"
  end

  test "should destroy Flight" do
    visit flight_url(@flight)
    click_on "Destroy this flight", match: :first

    assert_text "Flight was successfully destroyed"
  end
end

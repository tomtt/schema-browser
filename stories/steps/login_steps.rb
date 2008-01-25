steps_for(:login) do
  Given "a username '$username'" do |username|
    @username = username
  end

  Given "a password '$password'" do |password|
    @password = password
  end

  Given "an email '$email'" do |email|
    @email = email
  end

  Given "there is no user with this username" do
    User.find_by_login(@username).should be_nil
  end

  When "the user logs in with username and password" do
    post "/sessions/create", :user => { :login => @username, :password => @password }
  end

  When "the user creates an account with username, password and email" do
    post "/users/create", :user => { :login => @username,
                                     :password => @password,
                                     :password_confirmation => @password,
                                     :email => @email }
  end

  Then "the login form should be shown again" do
    response.should render_template("sessions/new")
  end

  Then "there should be a user named '$username'" do |username|
    User.find_by_login(username).should_not be_nil
  end

  Then "should redirect to '$path'" do |path|
    response.should redirect_to(path)
  end
end

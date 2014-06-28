
# it "should not display help-box if user preference is set" do
# user = create_and_login_user
# user.preferences[:show_help] = false
# user.save
# get :index
# response.body
#   .should =~ /<div id='help-box' class='well' style='display:none'>/
# response.body.should =~ /<a id='show-help-box' href='#'>/
# end

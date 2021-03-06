require "tilt/erubis"
require "sinatra"
require "sinatra/reloader"
require "yaml"

before do
  user_data = Psych.load_file("data/users.yaml")
  @users = user_data.map do |user|
    { name: user.first,
      email: user[1][:email],
      interests: user[1][:interests] }
  end
end

helpers do
  def count_interests
    @users.reduce(0) do |sum, user|
      sum + user[:interests].length
    end
  end
end

get "/" do
  erb :home
end

get "/:user_name" do
  next if params[:user_name] == "favicon.ico"

  user_name = params[:user_name].to_sym

  redirect "/" unless @users.any? { |user| user[:name] == user_name }

  @name = user_name

  @user = @users.select { |user| user[:name] == user_name }.first

  puts @user

  #File.write("#{Time.now}--users-logs.txt", "user_name = #{user_name}\n\n" +
  # "@name = #{@name}\n\n@users = #{@users}\n\n@user = #{@user}")

  erb :user_info do
    erb :links_other_users
  end
end

not_found do
  "<h2>404 NOT FOUND</h2>"
end
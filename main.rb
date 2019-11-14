require 'sinatra'
require 'sinatra/reloader'
require './model'

#use Rack::Session::Pool, :expire_after => 120
 
 
configure do
  enable :sessions
  set :username, 'xiangyu'
  set :passwordmd5, '0efe415c937f6858550a6378f4f3f374'  #'sinatra'
end
 
# login & logout
get '/' do
    if session[:admin] == true
        redirect to('index')
    else
        redirect to('login')
    end
end
 
get '/login' do
  erb :login
end
 
post '/login' do
    if params[:username] == settings.username && Digest::MD5.hexdigest(params[:password]) == settings.passwordmd5
        session[:admin] = true
        redirect to('index')
    else
        erb :login
    end
end
 
get '/index' do
    halt(401,'Not Authorized') unless session[:admin]
    @admin = session[:admin]
    erb :index
end
 
get '/logout' do
    session.clear
    redirect to('/login')
end

# student
get '/students/main' do
  halt(401,'Not Authorized') unless session[:admin]
  @admin = session[:admin]
	erb :student_main
end

get '/students/showall' do
  halt(401,'Not Authorized') unless session[:admin]
  @admin = session[:admin]
  @students = Student.all
  if (@students.size == 0) then erb :array_empty
  else erb :student_showall
  end


end

get '/students/getinfo/:id' do
  halt(401,'Not Authorized') unless session[:admin]
  @admin = session[:admin]

  @student = Student.get(params[:id].delete(":"))
  if @student
    erb :student_showinfo
  else
    "this id #{params[:id]} is not saved in database please refresh brower"
  end


end

get '/students/new' do
  halt(401,'Not Authorized') unless session[:admin]
  @admin = session[:admin]
	erb :student_new

end

post '/students/save' do
  if (params[:return]) then redirect to('/students/main')
  else
    if (params[:firstname].empty?) then firstname = "default firstname"
    else firstname = params[:firstname]
    end
    if (params[:lastname].empty?) then lastname = "default lastname"
    else lastname = params[:lastname]
    end
    if (params[:birthday].empty?) then birthday = "default birthday"
    else birthday = params[:birthday]
    end
    if (params[:address].empty?) then address = "default address"
    else address = params[:address]
    end
    if (params[:password].empty?) then password = "default password"
    else password = params[:password]
    end
	Student.create(firstname: firstname,
		lastname: lastname, birthday: birthday, address: address,
		password: password)

  redirect to('success')
  end

end

post '/students/edit_delete' do
  if (params[:edit])
    student = Student.get(params[:id])
    student.update(firstname:params[:firstname],
                   lastname: params[:lastname], birthday: params[:birthday], address: params[:address],
                   password: params[:password])
    redirect to ('students/success')
  elsif (params[:delete])
    student = Student.get(params[:id])
    student.destroy
    redirect to ('students/success')
  elsif (params[:return])
    redirect to ('students/showall')
  end

end

get '/students/success' do
  halt(401,'Not Authorized') unless session[:admin]
  @admin = session[:admin]
  erb :student_success
end



# comments
get '/comments/main' do
  halt(401,'Not Authorized') unless session[:admin]
  @admin = session[:admin]
  erb :comment_main
end

get '/comments/showall' do
  halt(401,'Not Authorized') unless session[:admin]
  @admin = session[:admin]
  @comments = Comment.all
  if (@comments.size == 0) then erb :array_empty
  else erb :comment_showall
  end
end

get '/comments/getinfo/:id' do
  halt(401,'Not Authorized') unless session[:admin]
  @admin = session[:admin]

  @comment = Comment.get(params[:id].delete(":"))
  if @comment
    erb :comment_showinfo
  else
    "this id #{params[:id]} is not saved in database please refresh brower"
  end


end

get '/comments/new' do
  halt(401,'Not Authorized') unless session[:admin]
  @admin = session[:admin]
  erb :comment_new
end

post '/comments/save' do
  if (params[:return]) then redirect to('/comments/main')
  else
    if (params[:title].empty?) then title = "default title"
      else title = params[:title]
    end
    if (params[:content].empty?) then content = "default content"
    else content = params[:content]
    end
    Comment.create(title: title,
                   content: content, created_at: Time.now)

    redirect to('success')
  end

end

post '/comments/edit_delete' do
  if (params[:edit])
    comment = Comment.get(params[:id])
    comment.update(title:params[:title],
                   content: params[:content])
    redirect to ('comments/success')
  elsif (params[:delete])
    comment = Comment.get(params[:id])
    comment.destroy
    redirect to ('comments/success')
  elsif (params[:return])
    redirect to ('comments/showall')
  end

end

get '/comments/success' do
  halt(401,'Not Authorized') unless session[:admin]
  @admin = session[:admin]
  erb :comment_success
end

#video
get '/video' do
  halt(401,'Not Authorized') unless session[:admin]
  @admin = session[:admin]
  erb :video
end


get '/success' do
  halt(401,'Not Authorized') unless session[:admin]
  @admin = session[:admin]
  erb :success
end

not_found do
  halt(401,'Not Authorized') unless session[:admin]
  @admin = session[:admin]
  @title = "not found page"
  erb :notfound, :layout => false
end
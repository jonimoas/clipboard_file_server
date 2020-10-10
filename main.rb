require 'sinatra'
require 'clipboard'
require 'fileutils'

post '/copy' do
  Clipboard.copy(params['text'])
  erb :form
end

get '/paste' do
  content = Clipboard.paste.encode("UTF-8")
  erb :paste,:locals=>{:content=>content}
end

post '/file' do
  unless File.directory?("files")
    FileUtils.mkdir_p("files")
  end
  @filename = params[:file][:filename]
  file = params[:file][:tempfile]
  File.open("./files/#{@filename}", 'wb') do |f|
    f.write(file.read)
  end
  erb :form
end

get '/file/:filename' do 
  headers['Content-Disposition'] = 'attachment';
  send_file("files/"+params['filename'])
end

get "/" do
  erb :form
end

get '/files' do
  @files = Dir.glob("./files/*.*").map{|f| f.split('/').last}
  erb :filelist
end


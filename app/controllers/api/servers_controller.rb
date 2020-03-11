class Api::ServersController < ApplicationController
  before_action :require_login

  def index
    @servers = current_user.subscribed_servers.includes(:subscribed_users, :subscriptions, :server_keys, :channels)
    @users = Array.new
    @subscriptions = Array.new
    @server_keys = Array.new
    @channels = Array.new
    @active_channels = Hash.new
    @servers.each do |server|
      @users += server.subscribed_users
      @subscriptions += server.subscriptions
      @server_keys += server.server_keys
      @channels += server.channels
      @active_channels[server.id] = server.channels.first.id if server.channels.first
    end
    @users.push current_user if @users.empty?
    render :index, status: 200
  end

  def create
    @server = Server.create(server_params)
    unless @server.id
      flash.now[:errors] = @server.errors.full_messages
      render partial: 'api/errors/server_errors', status: 422
    else
      @server_key = ServerKey.create(server_id: @server.id)
      @subscription = Subscription.create(user_id: current_user.id, server_id: @server.id)
      @channels = @server.channels
      @active_channels = Hash.new
      @active_channels[@server.id] = @channels.first.id
      render :create, status: 200
    end
  end

  def update
    @server = Server.find_by(id: params[:id])
    unless @server
      flash.now[:errors] = ['Server not found.'] 
      render partial: 'api/errors/server_errors', status: 404
    else
      unless @server.owner_id == current_user.id
        flash.now[:errors] = ['You do not own this server.']
        render partial: 'api/errors/server_errors', status: 403
      else
        unless @server.update(server_params)
          flash.now[:errors] = @server.errors.full_messages
          render partial: 'api/errors/server_errors', status: 422
        else
          render :update, status: 200
        end
      end
    end
  end

  def destroy
    @server = Server.find_by(id: params[:id])
    if @server
      if @server.owner_id == current_user.id
        if @server.destroy
          render :destroy, status: 200
        else
          flash.now[:errors] = @server.errors.full_messages
          render partial: 'api/errors/server_errors', status: 422
        end
      else
        flash.now[:errors] = ['You do not own this server.']
        render partial: 'api/errors/server_errors', status: 403
      end
    else
      flash.now[:errors] = ['Server not found.'] 
      ender partial: 'api/errors/server_errors', status: 404
    end
  end

  def server_params
    serv_params = params.require(:server).permit(:name, :private, :image)
    serv_params[:owner_id] = current_user.id
    serv_params
  end
end

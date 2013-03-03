class FacebookTabAppController < ApplicationController
  def signup
  end

  def load_account
    @user = current_user

    # Redirect users not signed in
    if @user.nil?
      redirect_to "/facebook_tab_app/signup"
    end

    # If the form has been filled in
    if not params[:user].nil?
      no_errors = @user.update_attributes(params[:user])

      if no_errors
        # Get friends from Facebook
        # NOTE: friend object returned from Facebook has the form:
        #   { "name" : "<friend name>", "id" : "<friend Facebook id>"}
        @graph = Koala::Facebook::API.new(@user.token)
        @user.ImportFriends(@graph.get_connections("me", "friends").map{
            |i| i["id"]})

        # Get organizations from Facebook
        orgs = @graph.get_connections("me", "accounts")

        # Only look at organizations that we administer
        orgs.select!{|o| not o["perms"].find_index("ADMINISTER").nil?}

        # Add the user as an admin if he is not already
        my_orgs = @user.organizations
        orgs.each do |org|
          if my_orgs.index{|o| o.facebook_id == org["id"]}.nil?
            org_object = Organization.find_by_facebook_id(org["id"])

            # Create the organization if it does not already exist
            if org_object.nil?
              org_object = Organization.create!(:name => org["name"],
                                                :facebook_id => org["id"])
            end

            # Make this user an admin
            org_object.users << @user
          end
        end

        # If there are organizations, load those
        @user.reload
        @organizations = @user.organizations
        if not @organizations.empty?
          render 'load_organizations'
        else
          redirect_to "/facebook_tab_app/done"
        end
      else
        render 'load_account'
      end
    end
  end

  def load_organizations
    # We already have set the user as an admin on all Organizations so only
    # delete them from Organizations they do not want to be associated with.
    if not params[:orgs_num].nil?
      params.each do |param|
        key = param.first
        value = param.second

        # Delete the organization objects with value 0
        # (params form: "org_<organization ID>")
        if key.starts_with? "org_" and value == "0"
          org = Organization.find_by_id(key.split("_")[1].to_i)

          # Only delete the Organization if this user is the only admin
          if not org.nil? and org.users.length == 1
            org.destroy
          end
        end
      end

      render 'done'
    end
  end

  def done
    @user = current_user

    # Redirect users not signed in
    if @user.nil?
      redirect_to "/facebook_tab_app/signup"
    end
  end
end

module Admin
  class NewslettersController < Admin::ApplicationController
    load_and_authorize_resource

    def create
      if @newsletter.save
        redirect_to edit_admin_newsletter_path(@newsletter)
      else
        render :new
      end
    end

    def update
      if @newsletter.update(newsletter_params)
        redirect_to edit_admin_newsletter_path(@newsletter)
      else
        render :edit
      end
    end

    def preview
      @user = User.new(name: Faker::Name.name, surname: Faker::Name.last_name, original_locale: SysLocale.all.sample)
      render inline: @newsletter.body, layout: 'newsletters/default'
    end

    def publish
      @newsletter.receiver = newsletter_params[:receiver]
      @newsletter.publish
      flash[:notice] = 'Newsletter pubblicata correttamente'
      redirect_back(fallback_location: root_path)
    end

    protected

    def newsletter_params
      params.require(:newsletter).permit(:subject, :body, :receiver)
    end
  end
end

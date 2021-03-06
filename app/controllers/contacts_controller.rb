class ContactsController < ApplicationController
  def new
    @contact = Contact.new
  end

  def confirm
    @contact = Contact.new(contact_params)

    # 内容に問題がなければ確認画面を表示する
    if @contact.valid?
      render :confirm
    # 内容に問題があればエラーメッセージを表示する
    else
      render :new
    end
  end

  def create
    @contact = Contact.new(contact_params)

    if @contact.save
      # お問い合わせした人にメール自動送信する
      NoticeMailer.sendmail_contact(@contact).deliver_now
      # 自分にお問い合わせを通知する
      NoticeMailer.sendmail_contact_me(@contact).deliver_now

      redirect_to contacts_complete_path
    else
      render :new
    end
  end

  private
  def contact_params
    params.require(:contact).permit(:contact_name, :contact_email, :body)
  end
end

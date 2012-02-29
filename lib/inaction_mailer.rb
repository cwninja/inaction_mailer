class InactionMailer < Mail::FileDelivery

  def deliver!(mail)
    InactionMailer.new_mail_file do |file|
      file.write mail.encoded
    end
  end

  class << self
    def new_mail_file(&block)
      ensure_output_dir_exists
      id = 0
      id += 1 while File.exist? "#{output_dir}/mail.#{id}.txt"
      File.open("#{output_dir}/mail.#{id}.txt", "w", &block)
    end

    protected
    def output_dir
      if defined? Rails.root
        "#{Rails.root}/tmp/sent_mails"
      else
        "sent_mails"
      end
    end

    def ensure_output_dir_exists
      Dir.mkdir output_dir unless File.directory? output_dir
    end
  end

end

ActionMailer::Base.add_delivery_method :inaction_file, InactionMailer

module ActionController
  module Flash
    FLASH_MESSAGE_TYPES = [ :error, :notice, :message, :warning ]

    class FlashHash
      def error=(msg)
        self[:error] = msg
      end
      def warning=(msg)
        self[:warning] = msg
      end
      def message=(msg)
        self[:message] = msg
      end
      def notice=(msg)
        self[:notice]=msg
      end

      def reset
        FLASH_MESSAGE_TYPES.each do |key|
          self[key] = nil
        end
      end

      def json(msg,type='notice',method=nil)
        h = {:flash => {:type => type, :message => msg}}
        h.merge!({:eval => {:method => method}}) if method
        h.to_json
      end

      def to_json(method=nil)
        h = Hash.new
        FLASH_MESSAGE_TYPES.each do |key|
          h = {:flash => {:type => key.to_s, :message => self[key].to_s}} unless self[key].blank?
          h.merge!({:eval => {:method => method.to_s}}) if h && method
          h = {:eval => {:method => method.to_s}} if !h && method 
        end
        h.to_json if h
      end

    end
  end
end

module EasyFlash
  module FlashMessageConductor
    FLASH_MESSAGE_TYPES = [ :error, :notice, :message, :warning ]

    module ViewHelpers
      def render_flash_message( css_class, message = "" )
        return "" if message.nil? or message.blank?
        content_tag( "p", message, :class => "#{css_class}" )
      end

      def render_flash_messages( div_id = "flash_messages", div_class = "" )
        div_content = ''
        FLASH_MESSAGE_TYPES.each do |key|
          div_content << render_flash_message( key.to_s, flash[key] ) unless flash[key].blank?
          flash[key] = nil # => clear the flash message so it doesnt show later
        end

        if div_content.blank?
          return content_tag( 'div', "", :id => div_id, :class => "")
        else
          return content_tag( 'div', div_content, :id => div_id, :class => div_class )
        end
      end

      def flash_message_set?
        flash_set = false
        FLASH_MESSAGE_TYPES.each do |key|
          flash_set = true unless flash[key].blank?
        end
        return flash_set
      end
    end
  end
end

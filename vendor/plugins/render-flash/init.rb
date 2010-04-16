# Include hook code here
require File.dirname(__FILE__) + '/lib/flash_renderer'

#ActionController::Base.send( :include, PlanetArgon::FlashMessageConductor::ControllerHelpers )
#ActionView::Base.send( :include, PlanetArgon::FlashMessageConductor::ViewHelpers )


#ActionController::Base.send( :include, EasyFlash::FlashMessageConductor::ControllerHelpers )
ActionView::Base.send( :include, EasyFlash::FlashMessageConductor::ViewHelpers )



# frozen_string_literal: true

# name: discourse-vin-onebox
# about: Adds support for VIN previews via the NHTSA VIN Decoder API
# version: 0.1
# authors: ChatGPT
# url: https://github.com/yourname/discourse-vin-onebox

enabled_site_setting :vin_onebox_enabled

register_asset "stylesheets/common/vin-onebox.scss"

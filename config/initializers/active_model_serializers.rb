# frozen_string_literal: true

# Config file for serializers
ActiveModelSerializers.config.adapter = :json_api
ActiveModelSerializers.config.key_transform = :camel_lower

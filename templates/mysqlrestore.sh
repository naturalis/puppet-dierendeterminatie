<%= @_pre_command -%>
duplicity --s3-use-new-style --s3-european-buckets <%= @_encryption -%> <%= @_target_url -%> <%= @restore_directory -%>

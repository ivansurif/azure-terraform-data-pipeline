variable "aad_group_name" {
  type        = string
  default     = "SMB Share Users"
  description = "Azure Active Directory Group for SMB Share users"
}


variable "smb_share_users" {
  description = "SMB Share users"
  default = [
    "cognite.test.user@gmail.com"
  ]
}
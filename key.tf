resource "aws_key_pair" "key_tf" {

  key_name   = "key_tf"
  public_key = file("${path.module}/rsa.pub")
  # Set name of 
  #             public_key => rsa.pub
  #             private_key => rsa.pem
}


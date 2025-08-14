
resource "aws_instance" "public_instance" {
  ami           = var.ec2_specs.ami
  instance_type = var.ec2_specs.instance_type
  subnet_id     = aws_subnet.public_subnet.id
  key_name      = data.aws_key_pair.key.key_name
  vpc_security_group_ids = [ aws_security_group.sg_public_instance.id ]
  user_data = file("scripts/userdata.sh")
  tags = {
    Name = "HelloWorld"
  }

  # lifecycle {
  #   create_before_destroy = true // crea y luego destruye si el apply tiene que hacerlo
  #   prevent_destroy = true // no va a destruir este recurso
  #   ignore_changes = [ 
  #     ami, // ignorará los cambios de la ami, pero no de los demas items
  #     subnet_id
  #    ]
  #    replace_triggered_by = [ 
  #     aws_subnet.private_subnet // Es para destruir y crear un recurso que quizas esta fuertemente ligado a por ejemplo en este caso la Private_subnet
  #     ]
  # }
}

data "aws_caller_identity" "current" {
  provider = aws.master
}


/* data "aws_vpc" "production" {
  provider = aws.master
  default  = true
}

data "aws_route_table" "production" {
  provider = aws.master

  route_table_id = "rtb-0952a06c"
  vpc_id         = data.aws_vpc.production.id
} */
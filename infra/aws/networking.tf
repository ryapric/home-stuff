#################
# Core / Shared #
#################
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  tags = merge(
    { Name = var.name_tag },
    local.default_tags
  )
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
}

##########
# Public #
##########
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = local.default_tags
}

resource "aws_route" "public" {
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main.id
  route_table_id         = aws_route_table.public.id
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true

  tags = merge(
    local.default_tags,
    { Name = "${var.name_tag}_public" }
  )
}

resource "aws_route_table_association" "public" {
  route_table_id = aws_route_table.public.id
  subnet_id      = aws_subnet.public.id
}

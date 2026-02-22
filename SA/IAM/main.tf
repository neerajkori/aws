# We will create 6 users[ram,sham,mohan,sundar,rahul,rajan] and create 2 groups [developer , operations]
# group 1 = Developer[ ram , sham, mohan,]
# group 2 = Operations[sundar,rahul]
# rajan will remain alone. 
#Create groups and users respectively and assign the users to the respective group. 
resource "aws_iam_group" "groups" {
  for_each = toset(var.groups)
  name     = each.value

}

resource "aws_iam_user" "users" {
  count = length(var.groups)
  for_each = toset(var.groups[count.index] )
  name     = each.value
}

resource "aws_iam_group_membership" "developer" {
  name = "developer"
  users = [
    aws_iam_user.users["ram"].name
  ]
  group = aws_iam_group.groups["developer"].name
}
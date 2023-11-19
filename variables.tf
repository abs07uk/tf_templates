variable "number_of_subnets" {

    type = number
    description = "the number of subnets"
    default = 4
    validation {
        condition = var.number_of_subnets < 6
        error_message = "The total number of subnets must be less than 6"
    }
}
@test "no args" {
  run terraform-wrapper.sh
  [ "${lines[0]}" = "**running locally**" ]
}

@test "plan" {
  run terraform-wrapper.sh plan
  [ "${lines[0]}" = "**running remotely**" ]
}

@test "plan with args" {
  run terraform-wrapper.sh plan -plan=tf.plan
  [ "${lines[0]}" = "**running remotely**" ]
}

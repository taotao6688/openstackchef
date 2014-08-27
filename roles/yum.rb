name "yum"
description "Setting up yum repositories"
run_list(
  "recipe[yum::ibm]"
)

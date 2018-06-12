# users
user =
  Toltec.Accounts.User.registration_changeset(%Toltec.Accounts.User{}, %{
    name: "some user",
    email: "user@toltec",
    password: "user@toltec"
  })

Toltec.Repo.insert!(user)

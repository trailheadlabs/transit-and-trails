FactoryGirl.define do
  factory :user do
    username 'testuser'
    email 'example@example.com'
    password 'please'
    password_confirmation 'please'
    admin false
    # required if the Devise Confirmable module is used
    confirmed_at Time.now
  end

  factory :admin, class: User do
    username 'testadmin'
    email 'admin@example.com'
    password 'please'
    password_confirmation 'please'
    admin true
    # required if the Devise Confirmable module is used
    confirmed_at Time.now
  end

  factory :django_user, class: User do
    username 'djangouser'
    email 'example@example.com'
    django_password 'sha1$69346$ded8d5952126f2a1a06218e619a6ffcd14b1bb70'
    confirmed_at Time.now
  end

end

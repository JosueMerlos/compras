FactoryBot.define do
  factory :usuario_1, class: Usuario do
    id         { 1 }
    email      { 'test@email.com' }
    nombre     { 'Usuario Test' }
  end

  factory :usuario_2, class: Usuario do
    id         { 2 }
    email      { 'guest@email.com' }
    nombre     { 'Usuario Guest' }
  end

  factory :usuario_3, class: Usuario do
    id         { 3 }
    email      { 'admin@email.com' }
    nombre     { 'Usuario Admin' }
  end
end

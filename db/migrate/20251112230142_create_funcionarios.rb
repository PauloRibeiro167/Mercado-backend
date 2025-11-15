class CreateFuncionarios < ActiveRecord::Migration[8.0]
  def change
    create_table :funcionarios do |t|
      t.string :nome
      t.string :cpf
      t.string :telefone
      t.string :email
      t.date :data_nascimento
      t.string :cargo
      t.decimal :salario, precision: 10, scale: 2
      t.references :user, null: false, foreign_key: true  

      t.timestamps
    end
  end
end

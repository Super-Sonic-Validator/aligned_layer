defmodule Batches do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  @primary_key {:merkle_root, :string, autogenerate: false}
  schema "batches" do
    field :amount_of_proofs, :integer
    field :is_verified, :boolean
    #new params:
    field :submition_block_number, :integer
    field :submition_transaction_hash, :string
    field :submition_timestamp, :utc_datetime
    field :response_block_number, :integer
    field :response_transaction_hash, :string
    field :response_timestamp, :utc_datetime
    field :data_pointer, :string
  end

  @doc false
  def changeset(new_batch, updates) do
    new_batch
    |> cast(updates, [:merkle_root, :amount_of_proofs, :is_verified])
    |> validate_required([:merkle_root, :amount_of_proofs, :is_verified])
    |> validate_format(:merkle_root, ~r/0x[a-fA-F0-9]{64}/)
    |> unique_constraint(:merkle_root)
    |> validate_number(:amount_of_proofs, greater_than: 0)
    |> validate_inclusion(:is_verified, [true, false])
    |> validate_number(:submition_block_number, greater_than: 0)
    |> validate_format(:submition_transaction_hash, ~r/0x[a-fA-F0-9]{64}/)
    |> validate_number(:response_block_number, greater_than: 0)
    |> validate_format(:response_transaction_hash, ~r/0x[a-fA-F0-9]{64}/)
  end

  # def cast_to_batches(%BatchDB{} = batch_db) do
  #   %Batches{
  #     merkle_root: batch_db.batch_merkle_root,
  #     amount_of_proofs: batch_db.amount_of_proofs,
  #     is_verified: batch_db.is_verified
  #   }
  # end

  def get_amount_of_submitted_proofs() do
    case Explorer.Repo.aggregate(Batches, :sum, :amount_of_proofs) do
      nil -> 0
      result -> result
    end
  end

  def get_amount_of_verified_proofs() do
    query = from(b in Batches,
      where: b.is_verified == true,
      select: sum(b.amount_of_proofs))

    case Explorer.Repo.one(query) do
      nil -> 0
      result -> result
    end
  end
end
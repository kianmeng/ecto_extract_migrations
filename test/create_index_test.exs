defmodule CreateIndexTest do
  use ExUnit.Case

  alias EctoExtractMigrations.Parsers.CreateIndex

  test "create_index" do
    sql = """
    CREATE INDEX t_eligibility_member_id_idx ON bnd.t_eligibility USING btree (member_id);
    """
    expected = %{
      key: [:member_id], name: "t_eligibility_member_id_idx", table_name: ["bnd", "t_eligibility"], using: "btree"
    }
    assert {:ok, expected} == CreateIndex.parse(sql)

    sql = """
    CREATE INDEX jpatient_refill_idx ON public.patient USING btree (((patient_fields ->> 'refill'::text)));
    """
    expected = %{
      key: ["(patient_fields ->> 'refill'::text)"],
      name: "jpatient_refill_idx", table_name: ["public", "patient"],
      using: "btree"
    }
    assert {:ok, expected} == CreateIndex.parse(sql)

    sql = """
    CREATE UNIQUE INDEX patient_facility_id_email_idx ON public.patient USING btree (facility_id, email) WHERE ((facility_id IS NOT NULL) AND (email IS NOT NULL));
    """
    expected = %{
      key: [:facility_id, :email],
      name: "patient_facility_id_email_idx",
      table_name: ["public", "patient"],
      using: "btree",
      unique: true,
      where: "(facility_id IS NOT NULL) AND (email IS NOT NULL)"
    }
    assert {:ok, expected} == CreateIndex.parse(sql)

  end

end

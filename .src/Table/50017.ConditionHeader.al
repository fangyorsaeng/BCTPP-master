table 50017 "Condition Template Customer"
{
    fields
    {
        field(1; "Condition Code"; Code[20])
        {
            TableRelation = Customer."No.";
            trigger OnValidate()
            var
                Cust: Record Customer;
            begin
                if "Condition Code" <> '' then begin
                    Cust.Reset();
                    Cust.SetRange("No.", "Condition Code");
                    if Cust.Find('-') then begin
                        "Customer Name" := Cust.Name;
                    end;
                end;
            end;
        }
        field(2; "Customer Name"; Text[200]) { }

        field(3; "Condition Type"; Option)
        {
            OptionMembers = Quote,Order,Invoice;
        }
        field(4; "Seq."; Integer)
        {

        }
        field(5; "Detail"; Text[200])
        {

        }
    }
    keys
    {
        key(key1; "Condition Code", "Condition Type", "Seq.") { }
    }

}
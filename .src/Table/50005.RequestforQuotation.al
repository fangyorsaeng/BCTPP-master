table 50005 "Request for Quotation"
{
    fields
    {
        field(1; "Entry No."; Integer) { AutoIncrement = true; Editable = false; }
        field(2; "RFQ No."; Code[30]) { }
        field(3; "Customer"; Code[20])
        {
            TableRelation = Customer."No.";
            trigger OnValidate()
            var
                Cust: Record Customer;
            begin
                if (Customer <> '') then begin
                    Cust.Reset();
                    Cust.SetRange("No.", Customer);
                    if Cust.Find('-') then begin
                        "Customer Name" := Cust.Name;
                        "Create By" := utility.UserFullName(UserId);
                        "Create Date" := CurrentDateTime;
                    end;

                end;

            end;
        }
        field(4; "Customer Name"; Text[250])
        {
            Editable = false;
        }
        field(5; "Received Date"; Date) { }
        field(6; "Request Submit Date"; Date) { }
        field(7; "No."; Integer) { }
        field(8; "Part No."; Code[50])
        {
            TableRelation = Item."No.";
            trigger OnValidate()
            var
                ItemS: Record Item;
            begin
                if "Part No." <> '' then begin
                    ItemS.Reset();
                    ItemS.SetRange("No.", "Part No.");
                    if ItemS.Find('-') then begin
                        "Part Name" := ItemS.Description;
                        Material := ItemS.Material;
                    end;
                end;
            end;
        }
        field(9; "Part Name"; Text[250])
        {

        }
        field(10; "Material"; Text[50])
        {

        }
        field(11; "Traget price"; Decimal) { }
        field(12; "Create By"; Text[50]) { Editable = false; }
        field(13; "Create Date"; DateTime) { Editable = false; }
        field(14; "Remark"; Text[250]) { }
        field(15; "Status"; Option)
        {
            OptionMembers = Open,Completed,Close,Cencel;
        }
        field(16; "Condition 1"; Decimal) { }
        field(17; "Condition 2"; Decimal) { }
        field(18; "Condition 3"; Decimal) { }
        field(19; "Condition 4"; Decimal) { }
        field(20; "Project Code"; Text[50]) { }
        field(21; "Condition"; Option)
        {
            OptionMembers = Finished,"Pre-Machined","Half-Finished","Semi-Finished","After Machining","After Turning";
        }
        field(22; "Product"; Text[50]) { }
        field(23; "Model"; Text[50]) { }
        field(24; "Model Life"; Integer) { }
        field(25; "ECR"; Text[50]) { }
        field(26; "SOP"; Text[50]) { }
        field(28; "Reply Status"; Option)
        {
            OptionMembers = Y,N;
        }
        field(29; "Quotation"; Text[50]) { }
        field(30; "Quotation Send Date"; Date) { }
    }
    keys
    {
        key(key1; "Entry No.") { }
    }
    var
        utility: Codeunit Utility;
}
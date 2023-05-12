tableextension 50028 "Invt.Document Header Ex" extends "Invt. Document Header"
{
    fields
    {
        modify("No.")
        {
            trigger OnAfterValidate()
            begin
                "Gen. Bus. Posting Group" := 'DOMESTIC';
                "Create Date" := CurrentDateTime;
                "Create By" := utility.UserFullName(UserId);
                "Posting No." := "No.";
            end;

        }
        field(50000; "Create Date"; DateTime)
        {

        }
        field(50001; "Create By"; Text[50])
        {

        }
        field(50100; "Scaner"; Code[100])
        {

        }
        field(50101; "Scan Item"; Option)
        {
            OptionMembers = Kanban,Item;
        }
        field(50002; "Ref.Doc"; Code[20])
        {

        }
        field(50003; "Customer"; Code[10])
        {
            TableRelation = Customer."No.";
        }


        modify("Document Date")
        {
            CaptionClass = 'Plan Delivery Date';
            trigger OnAfterValidate()
            begin
                if "Create By" = '' then begin
                    "Create Date" := CurrentDateTime;
                    "Create By" := utility.UserFullName(UserId);
                end;
            end;
        }
    }
    trigger OnInsert()
    begin
        Validate("Gen. Bus. Posting Group", 'DOMESTIC');
        "Create Date" := CurrentDateTime;
        "Create By" := utility.UserFullName(UserId);
        "Posting No." := "No.";
        "Posting No. Series" := '';
        Validate("Location Code", 'WHS');
    end;



    var
        utility: Codeunit Utility;
}
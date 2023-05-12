tableextension 50011 "WhseReceipt Line Ex" extends "Warehouse Receipt Line"
{
    fields
    {
        modify("Qty. to Receive")
        {
            trigger OnAfterValidate()
            begin
                if ("Qty. to Receive" > 0) then begin
                    //Validate(Quantity, "Qty. to Receive");
                    // Validate("Qty. (Base)", "Qty. to Receive (Base)");
                    // Quantity := "Qty. to Receive";
                    //  "Qty. (Base)" := "Qty. to Receive (Base)";


                end;

            end;
        }
        field(50005; "Grade"; Text[50])
        {

        }
        field(50006; "Size"; Text[30])
        {

        }
        field(50007; "Heat"; Text[50])
        {

        }
        field(50008; "Inspection"; Text[30])
        {

        }

    }
}
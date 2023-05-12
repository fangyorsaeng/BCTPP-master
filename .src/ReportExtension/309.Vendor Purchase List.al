reportextension 50002 "Vendor Purchase List Ex" extends "Vendor - Purchase List"
{
    dataset
    {
        add(Vendor)
        {
            column(Amount2; Amount2)
            {

            }
        }
        modify(Vendor)
        {
            trigger OnAfterAfterGetRecord()
            begin
                Amount2 := 0;
                PurL.Reset();
                PurL.SetRange("Document Type", PurL."Document Type"::Order);
                PurL.SetRange("Buy-from Vendor No.", Vendor."No.");
                if format(Vendor."Date Filter") <> '' then
                    PurL.SetRange("Document Date", Vendor."Date Filter");
                PurL.SetFilter("No.", '<>%1', '');
                if PurL.Find('-') then begin
                    repeat
                        Amount2 += PurL."Line Amount";
                    until PurL.Next = 0;
                end;
            end;
        }

    }
    var
        Amount2: Decimal;
        PurL: Record "Purchase Line";
}

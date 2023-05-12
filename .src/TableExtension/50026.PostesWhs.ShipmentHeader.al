tableextension 50026 "Posted Whs. Shipment H" extends "Posted Whse. Shipment Header"
{
    fields
    {
        field(50000; "Create Date"; DateTime)
        {

        }
        field(50001; "Create By"; Text[50])
        {

        }
        field(50002; "Ship By"; Text[50])
        {
            TableRelation = "Salesperson/Purchaser".Code;
        }

        field(50010; "Ref. Invoice No"; Text[50])
        {

        }
    }
}
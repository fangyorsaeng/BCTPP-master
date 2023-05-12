pageextension 50046 "Inventory Shipment List" extends "Invt. Shipments"
{
    layout
    {
        modify("No.")
        {
            CaptionClass = 'Shipment No.';
        }
        modify("External Document No.")
        {
            Caption = 'Ref. Doc No.';
        }

        modify("Document Date") { Visible = true; }

        modify("Posting Date")
        {
            Caption = 'Shipment Date';
            Visible = true;

        }
        modify("Posting Description")
        {
            CaptionClass = 'Remark';
        }
        moveafter("No."; "Posting Date", "Document Date", "External Document No.", "Posting Description", "Location Code")
        addafter("Location Code")
        {
            field("Salesperson/Purchaser Code"; "Salesperson/Purchaser Code")
            {
                Caption = 'Ship By';
                ApplicationArea = all;
            }
            field(Status; Status)
            {
                ApplicationArea = all;
            }
            field("Create Date"; "Create Date")
            {
                ApplicationArea = all;
            }
            field("Create By"; "Create By")
            {
                ApplicationArea = all;
            }

        }


    }
    actions
    {
        addlast(Creation)
        {
            action(PostedShipment)
            {
                Caption = 'Posted Shipment';
                ApplicationArea = all;
                Image = PostedShipment;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                trigger OnAction()
                var
                    PostedShpt: page "Posted Invt. Shipment Line";
                begin
                    Clear(PostedShpt);
                    PostedShpt.Run();
                end;

            }
            action(PostedShipment2)
            {
                Caption = 'Posted Shipment Lists';
                ApplicationArea = all;
                Image = PostedShipment;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = page "Posted Invt. Shipments";

            }
        }
    }
}
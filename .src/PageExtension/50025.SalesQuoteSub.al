pageextension 50025 "Sales Quote Sub Ex" extends "Sales Quote Subform"
{

    layout
    {
        modify("No.")
        {
            CaptionClass = 'Part No.';
        }
        modify(Description)
        {
            CaptionClass = 'Part Name';
        }
        moveafter("Qty. Assigned"; "Location Code")
        modify("Item Reference No.")
        {
            Visible = false;
        }
        modify("Description 2")
        {
            Visible = true;
            Caption = 'Model';
        }
        modify("Unit Price")
        {
            Caption = 'Initial Die Cost';
            ShowCaption = true;
            ShowMandatory = false;
            CaptionClass = 'Initial Die Cost';
            // SalesLineCaptionClassMgmt.GetSalesLineCaptionClass(Rec, 22);
            //CaptionML = ENA = 'Initial Die Cost';
        }
        modify("Line Amount") { Visible = false; }
        modify("Qty. to Assemble to Order") { Visible = false; }
        modify("Tax Group Code") { Visible = false; }
        modify("Line Discount %") { Visible = false; }
        modify("Qty. Assigned") { Visible = false; }
        modify("Qty. to Assign") { Visible = false; }
        addafter("Qty. Assigned")
        {
            field("Annual Usage"; "Annual Usage Text")
            {
                ApplicationArea = all;
                Caption = 'Usage';

            }
            field("Annual Usage Amount"; "Annual Usage Amount")
            {
                ApplicationArea = all;
                Caption = 'Price/Piece';
            }
        }
        modify("Location Code") { Visible = false; }



    }
    var
        SalesLineCaptionClassMgmt: Codeunit "Sales Line CaptionClass Mgmt";
}
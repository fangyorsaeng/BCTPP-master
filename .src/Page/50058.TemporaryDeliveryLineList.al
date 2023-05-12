page 50058 "Temporary Delivery Line List"
{
    SourceTable = "Temporary DL Req. Line";
    Editable = false;
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    layout
    {
        area(Content)
        {
            repeater(Control1)
            {
                field("Document No."; "Document No.")
                {
                    ApplicationArea = all;
                }
                field("Docu. Date"; "Docu. Date")
                {
                    ApplicationArea = all;
                }
                field("Line No."; "Line No.")
                {
                    ApplicationArea = all;
                }
                field("Part No."; "Part No.")
                {
                    ApplicationArea = all;
                }
                field("Part Name"; "Part Name")
                {
                    ApplicationArea = all;
                }
                field(Quantity; Quantity)
                {
                    ApplicationArea = all;
                }
                field("Remain Qty"; "Remain Qty")
                {
                    ApplicationArea = all;
                }
                field("Transfer From Item No."; "Transfer From Item No.")
                {
                    ApplicationArea = all;
                }

            }
        }
    }
}
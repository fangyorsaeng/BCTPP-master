page 50003 "Request for Quotation"
{
    ApplicationArea = All;
    Caption = 'Request for Quotation';
    PageType = List;
    SourceTable = "Request for Quotation";
    UsageCategory = Lists;


    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("RFQ No."; "RFQ No.")
                {
                    ApplicationArea = all;
                }
                field(Customer; Rec.Customer)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Customer field.';
                }
                field("Customer Name"; Rec."Customer Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Customer Name field.';
                }
                field("Received Date"; Rec."Received Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Received Date field.';
                }
                field("Request Submit Date"; Rec."Request Submit Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Request Submit Date field.';
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the No. field.';
                }
                field("Part No."; Rec."Part No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Part No. field.';
                }
                field("Part Name"; Rec."Part Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Part Name field.';
                }
                field("Condition 1"; "Condition 1") { }
                field("Condition 2"; "Condition 2") { }
                field("Condition 3"; "Condition 3") { }
                field("Condition 4"; "Condition 4") { }
                field("Project Code"; "Project Code") { }
                field(Condition; Condition) { }
                field(Product; Product) { }
                field(Model; Model) { }
                field("Model Life"; "Model Life") { }
                field(ECR; ECR) { }
                field(SOP; SOP) { }
                field("Reply Status"; "Reply Status") { }
                field(Quotation; Quotation) { }
                field("Quotation Send Date"; "Quotation Send Date") { }
                field(Material; Rec.Material)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Material field.';
                }
                field("Traget price"; Rec."Traget price")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Traget price field.';
                }
                field(Remark; Rec.Remark)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Remark field.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Status field.';
                }
                field("Create By"; Rec."Create By")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Create By field.';
                    Editable = false;
                }
                field("Create Date"; Rec."Create Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Create Date field.';
                    Editable = false;
                }
            }
        }
    }
}

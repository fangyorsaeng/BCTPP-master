tableextension 50000 "Item Ext" extends Item
{
    fields
    {

        modify("No.")
        {
            trigger OnAfterValidate()
            begin
                "Create By" := utility.UserFullName(UserId);
                "Create Date" := CurrentDateTime;
            end;
        }
        field(50000; "PCS per Pallet"; Decimal)
        {
            Caption = 'PCS Per Box/Pallet';
        }
        field(50001; "Group PD"; Enum "Prod. Process")
        {
            // OptionMembers = PD1,PD2,PD3,PD4,PD5,SGA,OTH,MFG;
            Caption = 'Section';
        }
        field(50002; "Customer Item No."; Text[250])
        {

        }
        field(50003; "Customer Item Name"; Text[250])
        {

        }
        field(50004; "Maker"; Text[150])
        {

        }
        field(50005; "Material"; Text[50])
        {

        }
        field(50006; "BOI"; Code[30])
        {
            TableRelation = "BOI List".Code;
        }
        field(50007; "Ref. Quotation"; Code[30])
        {
            //TableRelation = "Document Attachment"."File Name" where("Table ID" = filter(27));
        }
        field(50008; "Classification"; Text[30]) { TableRelation = CLASSFICATION."No."; }
        field(50009; "Location"; Code[20]) { TableRelation = Location.Code; }
        field(50010; "Vendor"; Text[200])
        {
            FieldClass = FlowField;
            CalcFormula = lookup(Vendor."Name" where("No." = field("Vendor No.")));
        }
        field(50011; "Qty. on PR"; Decimal)
        {
            AccessByPermission = TableData "Purch. Rcpt. Header" = R;
            CalcFormula = Sum("Purchase Line"."Outstanding Qty. (Base)" WHERE("Document Type" = CONST(Quote),
                                                                               Type = CONST(Item),
                                                                               "No." = FIELD("No."),
                                                                               "PO Status" = filter(Open),
                                                                               "PO No." = filter(''),
                                                                               "Location Code" = FIELD("Location Filter"),
                                                                               "Expected Receipt Date" = FIELD("Date Filter")
                                                                               ));
            Caption = 'Qty. on PR';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(50012; "Order Q"; Decimal)
        {

        }
        field(50013; "Vendor Name"; Text[100])
        {

        }
        field(50014; "TypeIM"; Text[20])
        {

        }
        field(50015; "Lead Time"; Text[50]) { }
        field(50016; "Qty on Supplier"; Decimal)
        {
            DecimalPlaces = 0 : 0;
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = sum("Temporary DL Req. Line"."Remain Qty" where("Remain Qty" = filter(> 0),
                                                                          "Part No." = field("No."), "Cut from Stock" = filter(true)));
        }
        field(50017; "Size"; Text[20]) { }
        field(50018; "Grade"; Text[20]) { }
        field(50019; "Plan Name"; Text[30]) { }
        field(50020; "Back No."; Code[20]) { }
        field(50099; "Create Date"; DateTime) { }
        field(50100; "Create By"; Text[50]) { }
        field(50200; "Default Customer"; Code[20]) { TableRelation = Customer."No."; }

        field(50201; "Customer"; Code[100])
        {
            FieldClass = FlowField;
            CalcFormula = lookup(Customer."Search Name" where("No." = field("Default Customer")));
        }

        field(50203; "Default Process"; Code[50])
        {
            TableRelation = "Process List"."Process Name";
        }
        field(50204; "Default Machine"; Code[50])
        {
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3));
        }
        field(50205; "Inventory 2"; Decimal)
        {
            CalcFormula = Sum("Item Ledger Entry".Quantity WHERE("Item No." = FIELD("No."),
                                                                  "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                                                                  "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter"),
                                                                  "Location Code" = filter('<>NG&<>PROCESS'),
                                                                  //  "Location Code" = filter(<> 'PROCESS'),
                                                                  "Drop Shipment" = FIELD("Drop Shipment Filter"),
                                                                  "Variant Code" = FIELD("Variant Filter"),
                                                                  "Lot No." = FIELD("Lot No. Filter"),
                                                                  "Serial No." = FIELD("Serial No. Filter"),
                                                                  "Unit of Measure Code" = FIELD("Unit of Measure Filter"),
                                                                  "Package No." = FIELD("Package No. Filter")));
            Caption = 'Inventory';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(50206; "NG Qty"; Decimal)
        {
            CalcFormula = Sum("Item Ledger Entry".Quantity WHERE("Item No." = FIELD("No."),
                                                                  "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                                                                  "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter"),
                                                                  "Location Code" = filter('NG'),
                                                                  "Drop Shipment" = FIELD("Drop Shipment Filter"),
                                                                  "Variant Code" = FIELD("Variant Filter"),
                                                                  "Lot No." = FIELD("Lot No. Filter"),
                                                                  "Serial No." = FIELD("Serial No. Filter"),
                                                                  "Unit of Measure Code" = FIELD("Unit of Measure Filter"),
                                                                  "Package No." = FIELD("Package No. Filter")));
            Caption = 'NG Qty';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(50207; "For Washing"; Boolean)
        {

        }
        field(50208; "Cut Stock"; Option)
        {
            OptionMembers = " ",BEFORE,ONPROCESS;
            Caption = 'Cut or Move (PDR,DLM)';
        }
        field(50220; "From Material Item"; Code[20])
        {
            TableRelation = Item."No.";
            Caption = 'From Material Item';
        }
        field(50221; "To Material Item"; Code[20])
        {
            TableRelation = Item."No.";
            Caption = 'To Material Item';
        }
        field(50235; "Inventory On Process"; Decimal)
        {
            CalcFormula = Sum("Item Ledger Entry".Quantity WHERE("Item No." = FIELD("No."),
                                                                  "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                                                                  "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter"),
                                                                   "Location Code" = filter('PROCESS'),
                                                                  "Drop Shipment" = FIELD("Drop Shipment Filter"),
                                                                  "Variant Code" = FIELD("Variant Filter"),
                                                                  "Lot No." = FIELD("Lot No. Filter"),
                                                                  "Serial No." = FIELD("Serial No. Filter"),
                                                                  "Unit of Measure Code" = FIELD("Unit of Measure Filter"),
                                                                  "Package No." = FIELD("Package No. Filter")));
            Caption = 'On Process';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(50236; "Include Plan List"; Boolean)
        {

        }
        field(50237; "Zone No."; Text[30])
        {

        }

    }
    fieldgroups
    {
        addlast(DropDown; Inventory, "Inventory Posting Group")
        {

        }

    }
    var
        utility: Codeunit Utility;
}
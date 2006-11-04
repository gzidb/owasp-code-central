<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xdt="http://www.w3.org/2005/xpath-datatypes" xmlns:date="http://exslt.org/dates-and-times" xmlns:n1="vuln_report" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:fn="http://www.w3.org/2005/xpath-functions" extension-element-prefixes="date">
	<!-- Define our report filters -->
	<xsl:variable name="filteredNodeList" select="/n1:Project/n1:Targets/n1:Target/n1:Findings/n1:Finding[@IncludeInReport='true']"/>
	<xsl:variable name="fo:layout-master-set">
		<!-- Master Document Layout -->
		<fo:layout-master-set>
			<fo:simple-page-master margin-left="0.6in" margin-right="0.6in" master-name="First-page" page-height="11in" page-width="8.5in">
				<fo:region-body margin-bottom="0.59in" margin-top="0.0in"/>
			</fo:simple-page-master>
			<fo:simple-page-master margin-left="0.6in" margin-right="0.6in" master-name="default-page" page-height="11in" page-width="8.5in">
				<fo:region-body margin-bottom="0.59in" margin-left="0.40in" margin-top="1.45in"/>
				<fo:region-before extent="1.22in"/>
				<fo:region-after extent="0.24in"/>
			</fo:simple-page-master>
			<fo:simple-page-master margin-left="0.3in" margin-right="0.3in" master-name="findings-page" page-height="8.5in" page-width="11in">
				<fo:region-body margin-bottom="0.79in" margin-top="1.05in"/>
				<fo:region-before extent="1.05in"/>
				<fo:region-after extent="0.24in"/>
			</fo:simple-page-master>
		</fo:layout-master-set>
		<!-- /Master Document Layout -->
	</xsl:variable>
	<xsl:output encoding="UTF-8" indent="no" media-type="text/html" omit-xml-declaration="no" version="1.0"/>
	<xsl:template match="/">
		<fo:root>
			<xsl:copy-of select="$fo:layout-master-set"/>
			<!-- Show Cover Page -->
			<fo:page-sequence format="1" initial-page-number="1" master-reference="First-page">
				<fo:flow flow-name="xsl-region-body">
					<fo:table table-layout="fixed" width="100%">
						<fo:table-column/>
						<fo:table-header>
							<fo:table-row>
								<fo:table-cell padding-bottom="-257mm">
									<fo:instream-foreign-object>
										<svg:svg xmlns:svg="http://www.w3.org/2000/svg" width="700px" height="500px">
											<svg:text x="295" y="95" transform="rotate(45)" font-family="Times" font-size="42pt" fill="rgb(240,240,240)">CONFIDENTIAL</svg:text>
										</svg:svg>
									</fo:instream-foreign-object>
								</fo:table-cell>
							</fo:table-row>
						</fo:table-header>
						<fo:table-body>
							<fo:table-row>
								<fo:table-cell>
									<xsl:call-template name="DisplayFirstPage"/>
								</fo:table-cell>
							</fo:table-row>
						</fo:table-body>
					</fo:table>
				</fo:flow>
			</fo:page-sequence>
			<!-- Section One Start -->
			<fo:page-sequence format="1" master-reference="default-page">
				<!-- Header -->
				<fo:static-content display-align="after" flow-name="xsl-region-before">
					<fo:block font-family="Times">
						<fo:table border-style="solid" border-width="1pt" space-before="20pt" table-layout="fixed" width="100%">
							<fo:table-column column-width="80pt"/>
							<fo:table-column/>
							<fo:table-column column-width="80pt"/>
							<fo:table-column/>
							<fo:table-body>
								<fo:table-row>
									<fo:table-cell background-color="#E0E0E0" border-style="solid" border-width="1pt" display-align="center" padding="4pt" text-align="start">
										<fo:block>Origin: </fo:block>
									</fo:table-cell>
									<fo:table-cell border-style="solid" border-width="1pt" display-align="center" padding="4pt" text-align="start">
										<fo:block>TSA Technical Security Assessment Report</fo:block>
									</fo:table-cell>
									<fo:table-cell background-color="#E0E0E0" border-style="solid" border-width="1pt" display-align="center" padding="4pt" text-align="start">
										<fo:block>Title: </fo:block>
									</fo:table-cell>
									<fo:table-cell border-style="solid" border-width="1pt" display-align="center" padding="4pt" text-align="start">
										<fo:block>
											<xsl:value-of select="/n1:Project/n1:ExecutiveSummary/n1:subtitle"/>
										</fo:block>
									</fo:table-cell>
								</fo:table-row>
							</fo:table-body>
						</fo:table>
					</fo:block>
				</fo:static-content>
				<!-- /Header -->
				<!-- Footer -->
				<fo:static-content display-align="after" flow-name="xsl-region-after">
					<fo:block font-family="Times">
						<fo:table margin-left="-45pt" margin-right="0pt" table-layout="fixed" width="100%">
							<fo:table-column/>
							<fo:table-column/>
							<fo:table-body>
								<fo:table-row>
									<fo:table-cell border-color="white" border-style="solid" border-width="0pt" display-align="center" padding="0pt" text-align="start">
										<fo:block color="black" font-family="Times" font-size="10pt" margin-left="0pt" space-before="-20pt" text-align="left"> Technical Security Assessment Report
                    </fo:block>
									</fo:table-cell>
									<fo:table-cell border-color="white" border-style="solid" border-width="0pt" display-align="center" padding="0pt" text-align="start">
										<fo:block color="black" font-family="Times" font-size="10pt" space-before="-20pt" text-align="right">
                    Page <fo:page-number/>
										</fo:block>
									</fo:table-cell>
								</fo:table-row>
							</fo:table-body>
						</fo:table>
					</fo:block>
				</fo:static-content>
				<!-- /Footer -->
				<fo:flow flow-name="xsl-region-body">
					<fo:table table-layout="fixed" width="100%">
						<fo:table-column/>
						<fo:table-header>
							<fo:table-row>
								<fo:table-cell padding-bottom="-257mm">
									<fo:instream-foreign-object>
										<svg:svg xmlns:svg="http://www.w3.org/2000/svg" width="700px" height="500px">
											<svg:text x="225" y="45" transform="rotate(45)" font-family="Times" font-size="42pt" fill="rgb(240,240,240)">CONFIDENTIAL</svg:text>
										</svg:svg>
									</fo:instream-foreign-object>
								</fo:table-cell>
							</fo:table-row>
						</fo:table-header>
						<fo:table-body>
							<fo:table-row>
								<fo:table-cell>
									<!-- Show Table of Contents -->
									<xsl:call-template name="DisplayTableOfContents">
										<xsl:with-param name="filteredNodeList">
											<xsl:value-of select="$filteredNodeList"/>
										</xsl:with-param>
									</xsl:call-template>
									<!-- Show Document Information Page -->
									<xsl:call-template name="DisplayDocumentInformation"/>
									<fo:block break-before="page"/>
									<!-- Show Executive Summary Page -->
									<fo:block font-family="Times">
										<xsl:for-each select="/n1:Project/n1:ExecutiveSummary/n1:level1">
											<xsl:call-template name="processLevel1Text">
												<xsl:with-param name="level1Name">
													<xsl:value-of select="@name"/>
												</xsl:with-param>
												<xsl:with-param name="level1Data">
													<xsl:value-of select="."/>
												</xsl:with-param>
											</xsl:call-template>
										</xsl:for-each>
									</fo:block>
									<!-- /Show Executive Summary Page -->
									<!-- Show Scanned Hosts Page -->
									<fo:block break-before="page"/>
									<fo:block font-family="Times">
										<xsl:call-template name="showScannedHosts">
											<xsl:with-param name="hosts" select="/n1:Project/n1:Targets"/>
										</xsl:call-template>
									</fo:block>
									<!-- /Show Scanned Hosts Page -->
								</fo:table-cell>
							</fo:table-row>
						</fo:table-body>
					</fo:table>
				</fo:flow>
			</fo:page-sequence>
			<!-- /Section One -->
			<!-- Section Two - Findings -->
			<fo:page-sequence master-reference="findings-page">
				<!-- Show Header -->
				<fo:static-content display-align="after" flow-name="xsl-region-before">
					<fo:block font-family="Times">
						<fo:table border-style="solid" border-width="1pt" space-before="20pt" table-layout="fixed" width="100%">
							<fo:table-column column-width="80pt"/>
							<fo:table-column/>
							<fo:table-column column-width="80pt"/>
							<fo:table-column/>
							<fo:table-body>
								<fo:table-row>
									<fo:table-cell background-color="#E0E0E0" border-style="solid" border-width="1pt" display-align="center" padding="4pt" text-align="start">
										<fo:block>Origin: </fo:block>
									</fo:table-cell>
									<fo:table-cell border-style="solid" border-width="1pt" display-align="center" padding="4pt" text-align="start">
										<fo:block>TSA Technical Security Assessment Report
                    </fo:block>
									</fo:table-cell>
									<fo:table-cell background-color="#E0E0E0" border-style="solid" border-width="1pt" display-align="center" padding="4pt" text-align="start">
										<fo:block>Title: </fo:block>
									</fo:table-cell>
									<fo:table-cell border-style="solid" border-width="1pt" display-align="center" padding="4pt" text-align="start">
										<fo:block>
											<xsl:value-of select="/n1:Project/n1:ExecutiveSummary/n1:subtitle"/>
										</fo:block>
									</fo:table-cell>
								</fo:table-row>
							</fo:table-body>
						</fo:table>
					</fo:block>
				</fo:static-content>
				<!-- /Header -->
				<!-- Show Footer -->
				<fo:static-content display-align="after" flow-name="xsl-region-after">
					<fo:block font-family="Times">
						<fo:table margin-left="-45pt" margin-right="0pt" table-layout="fixed" width="100%">
							<fo:table-column/>
							<fo:table-column/>
							<fo:table-body>
								<fo:table-row>
									<fo:table-cell border-color="white" border-style="solid" border-width="0pt" display-align="center" padding="0pt" text-align="start">
										<fo:block color="black" font-family="Times" font-size="10pt" margin-left="0pt" space-before="-20pt" text-align="left"> Technical Security Assessment Report
                    </fo:block>
									</fo:table-cell>
									<fo:table-cell border-color="white" border-style="solid" border-width="0pt" display-align="center" padding="0pt" text-align="start">
										<fo:block color="black" font-family="Times" font-size="10pt" space-before="-20pt" text-align="right">
                    Page <fo:page-number/>
										</fo:block>
									</fo:table-cell>
								</fo:table-row>
							</fo:table-body>
						</fo:table>
					</fo:block>
				</fo:static-content>
				<!-- /Footer -->
				<fo:flow flow-name="xsl-region-body">
					<fo:table table-layout="fixed" width="100%">
						<fo:table-column/>
						<fo:table-header>
							<fo:table-row>
								<fo:table-cell padding-bottom="-257mm">
									<fo:instream-foreign-object>
										<svg:svg xmlns:svg="http://www.w3.org/2000/svg" width="1000px" height="400px">
											<svg:text x="295" y="-60" transform="rotate(45)" font-family="Times" font-size="42pt" fill="rgb(240,240,240)">CONFIDENTIAL</svg:text>
										</svg:svg>
									</fo:instream-foreign-object>
								</fo:table-cell>
							</fo:table-row>
						</fo:table-header>
						<fo:table-body>
							<fo:table-row>
								<fo:table-cell>
									<xsl:variable name="RecommendationsDatabase">
										<xsl:value-of select="document('U:\_recommendationsDatabase\recommendationsDatabase.xml')"/>
									</xsl:variable>
									<fo:block font-family="Times">
										<xsl:attribute name="id">AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAFindings</xsl:attribute>
										<fo:block color="#000000" font-size="16pt" font-weight="bold"> 3.
            Findings </fo:block>
										<fo:block margin-left="0pt">
											<fo:instream-foreign-object>
												<svg:svg xmlns:svg="http://www.w3.org/2000/svg" width="750" height="2">
													<svg:line x1="0" y1="0" x2="750" y2="0" style="stroke:rgb(00,00,00);stroke-width:2"/>
												</svg:svg>
											</fo:instream-foreign-object>
										</fo:block>
										<xsl:if test="count($filteredNodeList/../..) = 0">
											<fo:block color="#111111" font-size="8pt" margin-right="2pt" wrap-option="wrap">No findings.</fo:block>
										</xsl:if>
										<xsl:for-each select="$filteredNodeList/../..">
											<xsl:call-template name="processTarget">
												<xsl:with-param name="targetData">
													<xsl:value-of select="."/>
												</xsl:with-param>
												<xsl:with-param name="RecommendationsDatabase">
													<xsl:value-of select="$RecommendationsDatabase"/>
												</xsl:with-param>
												<xsl:with-param name="ItemNumber">
													<xsl:value-of select="position()"/>
												</xsl:with-param>
											</xsl:call-template>
										</xsl:for-each>
										<!-- /Show Findings -->
									</fo:block>
									<!-- Show Recommendations Page -->
									<xsl:call-template name="showRecommendationDatabase">
										<xsl:with-param name="RecommendationsDatabase">
											<xsl:value-of select="$RecommendationsDatabase"/>
										</xsl:with-param>
										<xsl:with-param name="filteredNodeList">
											<xsl:value-of select="$filteredNodeList"/>
										</xsl:with-param>
									</xsl:call-template>
									<!-- /Recommendations -->
									<fo:block id="end"/>
								</fo:table-cell>
							</fo:table-row>
						</fo:table-body>
					</fo:table>
				</fo:flow>
			</fo:page-sequence>
			<!-- /Section Two - Findings -->
		</fo:root>
	</xsl:template>
	<!-- *** Definitions *** -->
	<!-- First Page Definition -->
	<xsl:template name="DisplayFirstPage">
		<fo:block font-family="Times">
			<fo:block space-before="20pt">
				<fo:external-graphic margin-right="290pt">
					<xsl:attribute name="src">url('<xsl:text disable-output-escaping="yes">Image Path Goes Here</xsl:text>')</xsl:attribute>
				</fo:external-graphic>
			</fo:block>
			<fo:block space-before="250pt">
				<fo:instream-foreign-object>
					<svg:svg xmlns:svg="http://www.w3.org/2000/svg" width="513" height="2">
						<svg:line x1="0" y1="0" x2="513" y2="0" style="stroke:rgb(00,00,00);stroke-width:2"/>
					</svg:svg>
				</fo:instream-foreign-object>
			</fo:block>
			<fo:block font-size="24pt" margin-right="13pt" text-align="right">
				<xsl:value-of select="/n1:Project/n1:ExecutiveSummary/n1:title"/>
			</fo:block>
			<fo:block font-size="18pt" margin-right="13pt" text-align="right">
				<xsl:value-of select="/n1:Project/n1:ExecutiveSummary/n1:subtitle"/>
			</fo:block>
		</fo:block>
	</xsl:template>
	<!-- /First Page Definition -->
	<!-- Table of Contents Difinition -->
	<xsl:template name="DisplayTableOfContents">
		<xsl:param name="filteredNodeList"/>
		<!--<fo:block break-before="page" />-->
		<fo:block font-family="Times">
			<fo:block color="#000000" font-size="16pt" font-weight="bold"> Table Of
      Contents </fo:block>
			<fo:block margin-left="0pt">
				<fo:instream-foreign-object>
					<svg:svg xmlns:svg="http://www.w3.org/2000/svg" width="468" height="2">
						<svg:line x1="0" y1="0" x2="468" y2="0" style="stroke:rgb(00,00,00);stroke-width:2"/>
					</svg:svg>
				</fo:instream-foreign-object>
			</fo:block>
			<fo:block end-indent="24pt" font-size="14pt" font-weight="bold" last-line-end-indent="-24pt" line-height="20pt" space-after="20pt" text-align-last="justify">
				<fo:inline keep-with-next.within-line="always"> 0. Document
        Information </fo:inline>
				<fo:inline keep-together.within-line="always">
					<fo:leader keep-with-next.within-line="always" leader-alignment="reference-area" leader-pattern="dots" leader-pattern-width="3pt"/>
					<fo:page-number-citation ref-id="DocumentInformation"/>
				</fo:inline>
				<fo:block end-indent="24pt" font-size="11pt" font-weight="normal" last-line-end-indent="-24pt" line-height="14pt" text-align-last="justify">
					<fo:inline keep-with-next.within-line="always">
						<fo:leader leader-length="30pt" leader-pattern="space"/> 0.1 Review Details
          </fo:inline>
					<fo:inline keep-together.within-line="always">
						<fo:leader keep-with-next.within-line="always" leader-alignment="reference-area" leader-pattern="dots" leader-pattern-width="3pt"/>
						<fo:page-number-citation>
							<xsl:attribute name="ref-id">ReviewDetails</xsl:attribute>
						</fo:page-number-citation>
					</fo:inline>
				</fo:block>
				<fo:block end-indent="24pt" font-size="11pt" font-weight="normal" last-line-end-indent="-24pt" line-height="14pt" text-align-last="justify">
					<fo:inline keep-with-next.within-line="always">
						<fo:leader leader-length="30pt" leader-pattern="space"/> 0.2 Revision Details
          </fo:inline>
					<fo:inline keep-together.within-line="always">
						<fo:leader keep-with-next.within-line="always" leader-alignment="reference-area" leader-pattern="dots" leader-pattern-width="3pt"/>
						<fo:page-number-citation>
							<xsl:attribute name="ref-id">RevisionDetails</xsl:attribute>
						</fo:page-number-citation>
					</fo:inline>
				</fo:block>
				<fo:block end-indent="24pt" font-size="11pt" font-weight="normal" last-line-end-indent="-24pt" line-height="14pt" text-align-last="justify">
					<fo:inline keep-with-next.within-line="always">
						<fo:leader leader-length="30pt" leader-pattern="space"/> 0.3 Related Documents
          </fo:inline>
					<fo:inline keep-together.within-line="always">
						<fo:leader keep-with-next.within-line="always" leader-alignment="reference-area" leader-pattern="dots" leader-pattern-width="3pt"/>
						<fo:page-number-citation>
							<xsl:attribute name="ref-id">RelatedDocuments</xsl:attribute>
						</fo:page-number-citation>
					</fo:inline>
				</fo:block>
			</fo:block>
			<fo:block end-indent="24pt" font-size="14pt" font-weight="bold" last-line-end-indent="-24pt" line-height="20pt" space-after="20pt" text-align-last="justify">
				<xsl:for-each select="/n1:Project/n1:ExecutiveSummary/n1:level1">
					<fo:inline keep-with-next.within-line="always">
						<xsl:number format="1. " level="single"/>
						<xsl:value-of select="@name"/>
					</fo:inline>
					<fo:inline keep-together.within-line="always">
						<fo:leader keep-with-next.within-line="always" leader-alignment="reference-area" leader-pattern="dots" leader-pattern-width="3pt"/>
						<fo:page-number-citation>
							<xsl:attribute name="ref-id"><xsl:value-of select="@name"/></xsl:attribute>
						</fo:page-number-citation>
					</fo:inline>
					<xsl:for-each select="n1:level2">
						<fo:block end-indent="24pt" font-size="11pt" font-weight="normal" last-line-end-indent="-24pt" line-height="14pt" text-align-last="justify">
							<fo:inline keep-with-next.within-line="always">
								<fo:leader leader-length="30pt" leader-pattern="space"/> 1.<xsl:number format="1 " level="single"/>
								<xsl:value-of select="@name"/>
							</fo:inline>
							<fo:inline keep-together.within-line="always">
								<fo:leader keep-with-next.within-line="always" leader-alignment="reference-area" leader-pattern="dots" leader-pattern-width="3pt"/>
								<fo:page-number-citation>
									<xsl:attribute name="ref-id"><xsl:value-of select="@name"/></xsl:attribute>
								</fo:page-number-citation>
							</fo:inline>
						</fo:block>
					</xsl:for-each>
				</xsl:for-each>
			</fo:block>
			<fo:block end-indent="24pt" font-size="14pt" font-weight="bold" last-line-end-indent="-24pt" line-height="20pt" space-after="20pt" text-align-last="justify">
				<fo:inline keep-with-next.within-line="always"> 2. Scanned Hosts</fo:inline>
				<fo:inline keep-together.within-line="always">
					<fo:leader keep-with-next.within-line="always" leader-alignment="reference-area" leader-pattern="dots" leader-pattern-width="3pt"/>
					<fo:page-number-citation ref-id="scannedHosts"/>
				</fo:inline>
				<fo:block end-indent="24pt" font-size="11pt" font-weight="normal" last-line-end-indent="-24pt" line-height="14pt" text-align-last="justify">
					<fo:inline keep-with-next.within-line="always">
						<fo:leader leader-length="30pt" leader-pattern="space"/> 2.1 All Hosts
          </fo:inline>
					<fo:inline keep-together.within-line="always">
						<fo:leader keep-with-next.within-line="always" leader-alignment="reference-area" leader-pattern="dots" leader-pattern-width="3pt"/>
						<fo:page-number-citation>
							<xsl:attribute name="ref-id">scannedHostsAll</xsl:attribute>
						</fo:page-number-citation>
					</fo:inline>
				</fo:block>
				<fo:block end-indent="24pt" font-size="11pt" font-weight="normal" last-line-end-indent="-24pt" line-height="14pt" text-align-last="justify">
					<fo:inline keep-with-next.within-line="always">
						<fo:leader leader-length="30pt" leader-pattern="space"/> 2.2 Hosts without Findings
          </fo:inline>
					<fo:inline keep-together.within-line="always">
						<fo:leader keep-with-next.within-line="always" leader-alignment="reference-area" leader-pattern="dots" leader-pattern-width="3pt"/>
						<fo:page-number-citation>
							<xsl:attribute name="ref-id">scannedHostsNoFindings</xsl:attribute>
						</fo:page-number-citation>
					</fo:inline>
				</fo:block>
			</fo:block>
			<fo:block end-indent="24pt" font-size="14pt" font-weight="bold" last-line-end-indent="-24pt" line-height="20pt" space-after="20pt" text-align-last="justify">
				<fo:inline keep-with-next.within-line="always"> 3. Findings
        </fo:inline>
				<fo:inline keep-together.within-line="always">
					<fo:leader keep-with-next.within-line="always" leader-alignment="reference-area" leader-pattern="dots" leader-pattern-width="3pt"/>
					<fo:page-number-citation ref-id="Findings"/>
				</fo:inline>
				<xsl:for-each select="$filteredNodeList/../..">
					<fo:block end-indent="24pt" font-size="11pt" font-weight="normal" last-line-end-indent="-24pt" line-height="14pt" text-align-last="justify">
						<fo:inline keep-with-next.within-line="always">
							<fo:leader leader-length="30pt" leader-pattern="space"/> 2.<!--<xsl:number
              format="1." level="single" />-->
							<xsl:value-of select="position()"/> &#160;<xsl:value-of select="@name"/>
						</fo:inline>
						<fo:inline keep-together.within-line="always">
							<fo:leader keep-with-next.within-line="always" leader-alignment="reference-area" leader-pattern="dots" leader-pattern-width="3pt"/>
								<fo:page-number-citation>
									<xsl:attribute name="ref-id"><xsl:value-of select="@name"/></xsl:attribute>
								</fo:page-number-citation>
						</fo:inline>
					</fo:block>
				</xsl:for-each>
			</fo:block>
			<fo:block end-indent="24pt" font-size="14pt" font-weight="bold" last-line-end-indent="-24pt" line-height="20pt" space-after="20pt" text-align-last="justify">
				<fo:inline keep-with-next.within-line="always"> 4. Recommendations
        </fo:inline>
				<fo:inline keep-together.within-line="always">
					<fo:leader keep-with-next.within-line="always" leader-alignment="reference-area" leader-pattern="dots" leader-pattern-width="3pt"/>
					<fo:page-number-citation ref-id="Recommendations"/>
				</fo:inline>
			</fo:block>
		</fo:block>
	</xsl:template>
	<!-- /Table of Contents Difinition -->
	<!-- Document Information Page Definition -->
	<xsl:template name="DisplayDocumentInformation">
		<fo:block break-before="page"/>
		<fo:block font-family="Times">
			<xsl:attribute name="id">DocumentInformation</xsl:attribute>
			<!-- /Documents Information - Information Block Definition -->
			<fo:block color="#000000" font-size="16pt" font-weight="bold"> 0.
      Document Information </fo:block>
			<fo:block margin-left="0pt">
				<fo:instream-foreign-object>
					<svg:svg xmlns:svg="http://www.w3.org/2000/svg" width="497" height="2">
						<svg:line x1="0" y1="0" x2="497" y2="0" style="stroke:rgb(00,00,00);stroke-width:2"/>
					</svg:svg>
				</fo:instream-foreign-object>
			</fo:block>
			<fo:table border-style="solid" border-width="1pt" space-before="20pt" table-layout="fixed" width="100%">
				<fo:table-column column-width="50pt"/>
				<fo:table-column column-width="80pt"/>
				<fo:table-column column-width="50pt"/>
				<fo:table-column/>
				<fo:table-column/>
				<fo:table-column column-width="120pt"/>
				<fo:table-body>
					<fo:table-row>
						<fo:table-cell background-color="#E0E0E0" border-style="solid" border-width="1pt" display-align="center" padding="4pt" text-align="start">
							<fo:block>Author:</fo:block>
						</fo:table-cell>
						<fo:table-cell border-style="solid" border-width="1pt" display-align="center" padding="4pt" text-align="start">
							<fo:block>
								<xsl:value-of select="/n1:Project/n1:Metadata/n1:contacts/n1:report_author/n1:Contact/@givenNames"/>&#160;<xsl:value-of select="/n1:Project/n1:Metadata/n1:contacts/n1:report_author/n1:Contact/@surname"/>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell background-color="#E0E0E0" border-style="solid" border-width="1pt" display-align="center" padding="4pt" text-align="start">
							<fo:block>Status:</fo:block>
						</fo:table-cell>
						<fo:table-cell border-style="solid" border-width="1pt" display-align="center" padding="4pt" text-align="start">
							<fo:block>Published</fo:block>
						</fo:table-cell>
						<fo:table-cell background-color="#E0E0E0" border-style="solid" border-width="1pt" display-align="center" padding="4pt" text-align="start">
							<fo:block>Issue Date:</fo:block>
						</fo:table-cell>
						<fo:table-cell border-style="solid" border-width="1pt" display-align="center" padding="4pt" text-align="start">
							<fo:block>16th March 2006</fo:block>
						</fo:table-cell>
					</fo:table-row>
					<fo:table-row>
						<fo:table-cell background-color="#E0E0E0" border-style="solid" border-width="1pt" display-align="center" number-columns-spanned="2" padding="4pt" text-align="start">
							<fo:block>Confidentiality Rating:</fo:block>
						</fo:table-cell>
						<fo:table-cell border-style="solid" border-width="1pt" display-align="center" number-columns-spanned="2" padding="4pt" text-align="start">
							<fo:block>Confidential</fo:block>
						</fo:table-cell>
						<fo:table-cell background-color="#E0E0E0" border-style="solid" border-width="1pt" display-align="center" padding="4pt" text-align="start">
							<fo:block>Section</fo:block>
						</fo:table-cell>
						<fo:table-cell border-style="solid" border-width="1pt" display-align="center" padding="4pt" text-align="start">
							<fo:block>TSA</fo:block>
						</fo:table-cell>
					</fo:table-row>
					<fo:table-row>
						<fo:table-cell background-color="#E0E0E0" border-style="solid" border-width="1pt" display-align="center" number-columns-spanned="2" padding="4pt" text-align="start">
							<fo:block>Approved By:</fo:block>
						</fo:table-cell>
						<fo:table-cell border-style="solid" border-width="1pt" display-align="center" number-columns-spanned="2" padding="4pt" text-align="start">
							<fo:block>TSA Technical Security Assessment</fo:block>
						</fo:table-cell>
						<fo:table-cell background-color="#E0E0E0" border-style="solid" border-width="1pt" display-align="center" padding="4pt" text-align="start">
							<fo:block>Signed:</fo:block>
						</fo:table-cell>
						<fo:table-cell border-style="solid" border-width="1pt" display-align="center" padding="4pt" text-align="start">
							<fo:block/>
						</fo:table-cell>
					</fo:table-row>
				</fo:table-body>
			</fo:table>
			<!-- /Documents Information - Information Block Definition -->
			<!-- Documents Information - Review Details Section Definition -->
			<fo:block color="#000000" font-size="13pt" font-weight="bold" space-before="20pt">
				<xsl:attribute name="id">ReviewDetails</xsl:attribute> 0.1 Review Details </fo:block>
			<fo:table border-style="solid" border-width="1pt" space-before="20pt" table-layout="fixed" width="100%">
				<fo:table-column column-width="50pt"/>
				<fo:table-column column-width="100pt"/>
				<fo:table-column column-width="150pt"/>
				<fo:table-column/>
				<fo:table-body>
					<fo:table-row>
						<fo:table-cell background-color="#E0E0E0" border-style="solid" border-width="1pt" display-align="center" padding="4pt" text-align="start">
							<fo:block>Version</fo:block>
						</fo:table-cell>
						<fo:table-cell background-color="#E0E0E0" border-style="solid" border-width="1pt" display-align="center" padding="4pt" text-align="start">
							<fo:block>Reviewed</fo:block>
						</fo:table-cell>
						<fo:table-cell background-color="#E0E0E0" border-style="solid" border-width="1pt" display-align="center" padding="4pt" text-align="start">
							<fo:block>Date</fo:block>
						</fo:table-cell>
						<fo:table-cell background-color="#E0E0E0" border-style="solid" border-width="1pt" display-align="center" padding="4pt" text-align="start">
							<fo:block>Detail</fo:block>
						</fo:table-cell>
					</fo:table-row>
					<fo:table-row>
						<fo:table-cell border-style="solid" border-width="1pt" display-align="center" padding="4pt" text-align="start">
							<fo:block>1.0</fo:block>
						</fo:table-cell>
						<fo:table-cell border-style="solid" border-width="1pt" display-align="center" padding="4pt" text-align="start">
							<fo:block>
								<xsl:value-of select="/n1:Project/n1:Metadata/n1:contacts/n1:report_reviewer/n1:Contact/@givenNames"/>&#160;<xsl:value-of select="/n1:Project/n1:Metadata/n1:contacts/n1:report_reviewer/n1:Contact/@surname"/>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell border-style="solid" border-width="1pt" display-align="center" padding="4pt" text-align="start">
							<fo:block>16th March 2006</fo:block>
						</fo:table-cell>
						<fo:table-cell border-style="solid" border-width="1pt" display-align="center" padding="4pt" text-align="start">
							<fo:block>Version 1.0</fo:block>
						</fo:table-cell>
					</fo:table-row>
				</fo:table-body>
			</fo:table>
			<!-- /Documents Information - Review Details Section Definition -->
			<!-- Documents Information - Revision History Section Definition -->
			<fo:block color="#000000" font-size="13pt" font-weight="bold" space-before="20pt">
				<xsl:attribute name="id">RevisionDetails</xsl:attribute> 0.2 Revision History
      </fo:block>
			<fo:table border-style="solid" border-width="1pt" space-before="20pt" table-layout="fixed" width="100%">
				<fo:table-column column-width="50pt"/>
				<fo:table-column column-width="100pt"/>
				<fo:table-column column-width="150pt"/>
				<fo:table-column/>
				<fo:table-body>
					<fo:table-row>
						<fo:table-cell background-color="#E0E0E0" border-style="solid" border-width="1pt" display-align="center" padding="4pt" text-align="start">
							<fo:block>Version</fo:block>
						</fo:table-cell>
						<fo:table-cell background-color="#E0E0E0" border-style="solid" border-width="1pt" display-align="center" padding="4pt" text-align="start">
							<fo:block>Author</fo:block>
						</fo:table-cell>
						<fo:table-cell background-color="#E0E0E0" border-style="solid" border-width="1pt" display-align="center" padding="4pt" text-align="start">
							<fo:block>Date</fo:block>
						</fo:table-cell>
						<fo:table-cell background-color="#E0E0E0" border-style="solid" border-width="1pt" display-align="center" padding="4pt" text-align="start">
							<fo:block>Detail</fo:block>
						</fo:table-cell>
					</fo:table-row>
					<fo:table-row>
						<fo:table-cell border-style="solid" border-width="1pt" display-align="center" padding="4pt" text-align="start">
							<fo:block>1.0</fo:block>
						</fo:table-cell>
						<fo:table-cell border-style="solid" border-width="1pt" display-align="center" padding="4pt" text-align="start">
							<fo:block>
								<xsl:value-of select="/n1:Project/n1:Metadata/n1:contacts/n1:report_author/n1:Contact/@givenNames"/>&#160;<xsl:value-of select="/n1:Project/n1:Metadata/n1:contacts/n1:report_author/n1:Contact/@surname"/>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell border-style="solid" border-width="1pt" display-align="center" padding="4pt" text-align="start">
							<fo:block>16th March 2006</fo:block>
						</fo:table-cell>
						<fo:table-cell border-style="solid" border-width="1pt" display-align="center" padding="4pt" text-align="start">
							<fo:block>Version 1.0</fo:block>
						</fo:table-cell>
					</fo:table-row>
					
				</fo:table-body>
			</fo:table>
			<!-- /Documents Information - Revision History Section Definition -->
			<!-- Documents Information - Related Documents Section Definition -->
			<fo:block color="#000000" font-size="13pt" font-weight="bold" space-before="20pt">
				<xsl:attribute name="id">RelatedDocuments</xsl:attribute> 0.3 Related documents
      </fo:block>
			<fo:table border-style="solid" border-width="1pt" space-before="20pt" table-layout="fixed" width="100%">
				<fo:table-column column-width="50pt"/>
				<fo:table-column column-width="100pt"/>
				<fo:table-column column-width="150pt"/>
				<fo:table-column/>
				<fo:table-body>
					<fo:table-row>
						<fo:table-cell background-color="#E0E0E0" border-style="solid" border-width="1pt" display-align="center" padding="4pt" text-align="start">
							<fo:block>Version</fo:block>
						</fo:table-cell>
						<fo:table-cell background-color="#E0E0E0" border-style="solid" border-width="1pt" display-align="center" padding="4pt" text-align="start">
							<fo:block>Author</fo:block>
						</fo:table-cell>
						<fo:table-cell background-color="#E0E0E0" border-style="solid" border-width="1pt" display-align="center" padding="4pt" text-align="start">
							<fo:block>Date</fo:block>
						</fo:table-cell>
						<fo:table-cell background-color="#E0E0E0" border-style="solid" border-width="1pt" display-align="center" padding="4pt" text-align="start">
							<fo:block>Detail</fo:block>
						</fo:table-cell>
					</fo:table-row>
					<fo:table-row>
						<fo:table-cell border-style="solid" border-width="1pt" display-align="center" padding="4pt" text-align="start">
							<fo:block>1.0</fo:block>
						</fo:table-cell>
						<fo:table-cell border-style="solid" border-width="1pt" display-align="center" padding="4pt" text-align="start">
							<fo:block>
								<xsl:value-of select="/n1:Project/n1:Metadata/n1:contacts/n1:report_author/n1:Contact/@givenNames"/>&#160;<xsl:value-of select="/n1:Project/n1:Metadata/n1:contacts/n1:report_author/n1:Contact/@surname"/>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell border-style="solid" border-width="1pt" display-align="center" padding="4pt" text-align="start">
							<fo:block>16th March 2006</fo:block>
						</fo:table-cell>
						<fo:table-cell border-style="solid" border-width="1pt" display-align="center" padding="4pt" text-align="start">
							<fo:block>TSA Findings – <xsl:value-of select="/n1:Project/n1:ExecutiveSummary/n1:subtitle"/> v1.0.doc</fo:block>
						</fo:table-cell>
					</fo:table-row>
				</fo:table-body>
			</fo:table>
		</fo:block>
	</xsl:template>
	<!-- /Documents Information - Related Documents Section Definition -->
	<!-- Document Information Page Definition -->
	<!-- Bold Style Definition -->
	<xsl:template match="b">
		<fo:inline font-weight="bold">
			<xsl:apply-templates/>
		</fo:inline>
	</xsl:template>
	<!-- /Bold Style Definition -->
	<!-- Newline Style Definition -->
	<xsl:template match="n1:newline">
		<fo:block>
			<fo:leader leader-pattern="space"/>
		</fo:block>
	</xsl:template>
	<!-- /Newline Style Definition -->
	<!-- List Style Definition -->
	<xsl:template match="n1:ul">
		<fo:block>
			<fo:list-block>
				<xsl:apply-templates/>
			</fo:list-block>
		</fo:block>
	</xsl:template>
	<xsl:template match="n1:li">
		<fo:list-item>
			<fo:list-item-label end-indent="label-end()" margin-left="10pt">
				<fo:block> - </fo:block>
			</fo:list-item-label>
			<fo:list-item-body start-indent="body-start()">
				<fo:block>
					<xsl:apply-templates/>
				</fo:block>
			</fo:list-item-body>
		</fo:list-item>
	</xsl:template>
	<!-- /List Style Definition -->
	<!-- Executive Summary Level 1 Style Definition -->
	<xsl:template name="processLevel1Text">
		<xsl:param name="level1Name"/>
		<xsl:param name="level1Data"/>
		<fo:block color="#000000" font-size="16pt" font-weight="bold">
			<xsl:attribute name="id"><xsl:value-of select="$level1Name"/></xsl:attribute>
			<xsl:number format="1." level="single"/>
			<xsl:value-of select="$level1Name"/>
		</fo:block>
		<fo:block margin-left="0pt">
			<fo:instream-foreign-object>
				<svg:svg xmlns:svg="http://www.w3.org/2000/svg" width="497" height="2">
					<svg:line x1="0" y1="0" x2="497" y2="0" style="stroke:rgb(00,00,00);stroke-width:2"/>
				</svg:svg>
			</fo:instream-foreign-object>
		</fo:block>
		<fo:block color="#111111" font-size="10pt" margin-right="-20pt" text-align="justify">
			<xsl:for-each select="$level1Data/n1:level2">
				<xsl:call-template name="processLevel2Text">
					<xsl:with-param name="level2Name">
						<xsl:value-of select="@name"/>
					</xsl:with-param>
					<xsl:with-param name="level2Data">
						<xsl:value-of select="."/>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:for-each>
		</fo:block>
	</xsl:template>
	<!-- Executive Summary Level 1 Style Definition -->
	<!-- Executive Summary Level 2 Style Definition -->
	<xsl:template name="processLevel2Text">
		<xsl:param name="level2Name"/>
		<xsl:param name="level2Data"/>
		<fo:block color="#000000" font-size="11pt" font-weight="bold" space-before="10pt">
			<xsl:attribute name="id"><xsl:value-of select="$level2Name"/></xsl:attribute> 1.<xsl:number format="1" level="single"/>.
    <xsl:value-of select="$level2Name"/>
		</fo:block>
		<fo:block color="#111111" font-size="10pt" margin-right="2pt" space-after="10pt" wrap-option="wrap" text-align="justify">
			<xsl:apply-templates select="$level2Data"/>
		</fo:block>
	</xsl:template>
	<!-- Executive Summary Level 2 Style Definition -->
	<!-- Target Style Definition -->
	<xsl:template name="processTarget">
		<xsl:param name="targetData"/>
		<xsl:param name="RecommendationsDatabase"/>
		<xsl:param name="ItemNumber"/>
		<!-- Name -->
		<fo:block color="#000000" font-size="11pt" font-weight="bold" space-before="20pt">
			<xsl:attribute name="id"><xsl:value-of select="$targetData/@name"/><!--MB Working--></xsl:attribute> 2.<xsl:value-of select="$ItemNumber"/> &#160;<!--<xsl:number format="1" level="multiple" />)-->
			<xsl:value-of select="$targetData/n1:IP/@value"/>
			<xsl:if test="$targetData/n1:IP/@value!=$targetData/n1:DnsName/@value"> (
    <xsl:value-of select="$targetData/n1:DnsName/@value"/> ) </xsl:if>
		</fo:block>
		<fo:block color="#111111" font-size="10pt" margin-right="-20pt" space-after="20pt" space-before="10pt">
			<fo:table border-color="black" border-style="solid" border-width="2px" padding="0pt" space-after.optimum="2pt" space-before.optimum="1pt" table-layout="fixed" width="100%">
				<fo:table-column column-width="40pt"/>
				<fo:table-column column-width="60pt"/>
				<fo:table-column column-width="60pt"/>
				<fo:table-column column-width="110pt"/>
				<fo:table-column column-width="225pt"/>
				<fo:table-column/>
				<fo:table-column column-width="40pt"/>
				<fo:table-column column-width="55pt"/>
				<fo:table-body>
					<xsl:call-template name="printTopOfFindingsTable"/>
					<xsl:for-each select="$targetData/n1:Findings/n1:Finding">
						<xsl:call-template name="processFinding">
							<xsl:with-param name="findingData">
								<xsl:value-of select="."/>
							</xsl:with-param>
							<xsl:with-param name="RecommendationsDatabase">
								<xsl:value-of select="$RecommendationsDatabase"/>
							</xsl:with-param>
						</xsl:call-template>
					</xsl:for-each>
				</fo:table-body>
			</fo:table>
		</fo:block>
	</xsl:template>
	<!-- /Target Style Definition -->
	<!-- Finding Style Definition -->
	<xsl:template name="processFinding">
		<xsl:param name="findingData"/>
		<xsl:param name="RecommendationsDatabase"/>
		<xsl:if test="$findingData/@IncludeInReport='true'">
			<fo:table-row padding="2pt">
				<fo:table-cell border-style="solid" padding="2pt">
					<fo:block color="#111111" font-size="8pt" margin-right="2pt" wrap-option="wrap">
						<xsl:apply-templates select="$findingData/@Tsa-id"/>
					</fo:block>
				</fo:table-cell>
				<fo:table-cell border-style="solid" padding="2pt">
					<fo:block color="#111111" font-size="8pt" margin-right="2pt" wrap-option="wrap">
						<xsl:value-of select="$findingData/@Layer"/>
					</fo:block>
				</fo:table-cell>
				<fo:table-cell border-style="solid" padding="2pt">
					<fo:block color="#111111" font-size="8pt" margin-right="2pt" wrap-option="wrap">
						<xsl:value-of select="$findingData/@Category"/>
					</fo:block>
				</fo:table-cell>
				<fo:table-cell border-style="solid" padding="2pt">
					<fo:block color="#111111" font-size="8pt" margin-right="2pt" wrap-option="wrap">
						<xsl:value-of select="$findingData/@Vulnerability"/>
					</fo:block>
				</fo:table-cell>
				<fo:table-cell border-style="solid" padding="2pt" width="50pt">
					<fo:block color="#111111" font-size="8pt" margin-right="2pt" wrap-option="wrap">
						<xsl:apply-templates select="$findingData/n1:AffectedItems"/>
					</fo:block>
				</fo:table-cell>
				<fo:table-cell border-style="solid" padding="2pt">
					<fo:block color="#111111" font-size="8pt" margin-right="2pt" wrap-option="wrap">
						<xsl:apply-templates select="$findingData/n1:Comments"/>
						<xsl:call-template name="Recommendation">
							<xsl:with-param name="RecommendationsDatabase">
								<xsl:value-of select="$RecommendationsDatabase"/>
							</xsl:with-param>
						</xsl:call-template>
					</fo:block>
				</fo:table-cell>
				<fo:table-cell border-style="solid" padding="2pt">
					<fo:block color="#111111" font-size="8pt" margin-right="2pt" wrap-option="wrap">
						<xsl:apply-templates select="$findingData/@Impact"/>
					</fo:block>
				</fo:table-cell>
				<fo:table-cell border-style="solid" padding="2pt">
					<fo:block color="#111111" font-size="8pt" margin-right="2pt" wrap-option="wrap">
						<xsl:apply-templates select="$findingData/@Probability"/>
					</fo:block>
				</fo:table-cell>
			</fo:table-row>
		</xsl:if>
	</xsl:template>
	<!-- Finding Style Definition -->
	<!-- Recommendation Style Definition -->
	<xsl:template name="Recommendation">
		<xsl:param name="RecommendationsDatabase"/>
		<xsl:for-each select="n1:Recommendation">
			<fo:block color="#111111" font-size="8pt" margin-right="2pt" wrap-option="wrap">
				<xsl:value-of select="n1Comment"/>
				<fo:list-block provisional-distance-between-starts="7mm" provisional-label-separation="2mm" space-after.optimum="4pt" space-before.optimum="4pt" start-indent="2mm">
					<xsl:for-each select="n1:linkToRecommendationDatabase">
						<fo:list-item>
							<fo:list-item-label end-indent="label-end()">
								<fo:block>•</fo:block>
							</fo:list-item-label>
							<fo:list-item-body start-indent="body-start()">
								<fo:block margin-left="10pt">
									<xsl:variable name="CurrentRecommendationID">
										<xsl:value-of select="."/>
									</xsl:variable>
									<xsl:value-of select="$CurrentRecommendationID"/>
									<xsl:if test="$RecommendationsDatabase/n1:Recommendations/n1:Recommendation/n1:Category[../n1:Id=$CurrentRecommendationID]">
                  - <xsl:value-of select="$RecommendationsDatabase/n1:Recommendations/n1:Recommendation/n1:Category[../n1:Id=$CurrentRecommendationID]"/>
									</xsl:if>
								</fo:block>
							</fo:list-item-body>
						</fo:list-item>
					</xsl:for-each>
				</fo:list-block>
			</fo:block>
		</xsl:for-each>
	</xsl:template>
	<!-- Recommendation Style Definition -->
	<!-- Recommendations Page Style Definition -->
	<xsl:template name="showRecommendationDatabase">
		<xsl:param name="RecommendationsDatabase"/>
		<xsl:param name="filteredNodeList"/>
		<fo:block break-before="page"/>
		<fo:block font-family="Times">
			<xsl:attribute name="id">Recommendations</xsl:attribute>
			<fo:block color="#000000" font-size="16pt" font-weight="bold">
      4. Recommendations </fo:block>
			<fo:block margin-left="0pt">
				<fo:instream-foreign-object>
					<svg:svg xmlns:svg="http://www.w3.org/2000/svg" width="750" height="2">
						<svg:line x1="0" y1="0" x2="750" y2="0" style="stroke:rgb(00,00,00);stroke-width:2"/>
					</svg:svg>
				</fo:instream-foreign-object>
			</fo:block>
			<fo:table border-color="black" border-style="solid" border-width="1px" padding="0" space-after.optimum="2pt" space-before.optimum="2pt" table-layout="fixed" width="100%">
				<fo:table-column column-width="50pt"/>
				<fo:table-column column-width="150pt"/>
				<fo:table-column column-width="150pt"/>
				<fo:table-column/>
				<fo:table-body>
					<fo:table-row background-color="#003399" color="#FFFFFF" text-align="left">
						<fo:table-cell border-style="solid" padding="2pt" text-align="left">
							<fo:block font-size="10pt" font-weight="bold">ID</fo:block>
						</fo:table-cell>
						<fo:table-cell border-style="solid" padding="2pt" text-align="left">
							<fo:block font-size="10pt" font-weight="bold">Layer</fo:block>
						</fo:table-cell>
						<fo:table-cell border-style="solid" padding="2pt">
							<fo:block font-size="10pt" font-weight="bold">Category</fo:block>
						</fo:table-cell>
						<fo:table-cell border-style="solid" padding="2pt">
							<fo:block font-size="10pt" font-weight="bold">Solution</fo:block>
						</fo:table-cell>
					</fo:table-row>
					<xsl:variable name="projectData">
						<xsl:value-of select="/n1:Project"/>
					</xsl:variable>
					<xsl:for-each select="$RecommendationsDatabase/n1:Recommendations/n1:Recommendation">
						<xsl:variable name="recommendationID">
							<xsl:value-of select="n1:Id"/>
						</xsl:variable>
						<xsl:if test="count($filteredNodeList/n1:Recommendation[n1:linkToRecommendationDatabase=$recommendationID])&gt;0">
							<fo:table-row>
								<fo:table-cell border-style="solid" display-align="center" padding="5pt" text-align="center">
									<fo:block color="#111111" font-size="10pt">
										<fo:inline font-weight="bold">
											<xsl:value-of select="n1:Id"/>
										</fo:inline>
									</fo:block>
								</fo:table-cell>
								<fo:table-cell border-style="solid" padding="5pt">
									<fo:block color="#111111" font-size="10pt">
										<xsl:value-of select="n1:Layer"/>
									</fo:block>
								</fo:table-cell>
								<fo:table-cell border-style="solid" padding="5pt">
									<fo:block color="#111111" font-size="10pt">
										<xsl:value-of select="n1:Category"/>
									</fo:block>
								</fo:table-cell>
								<fo:table-cell border-style="solid" padding="5pt">
									<fo:block color="#111111" font-size="10pt">
										<xsl:value-of select="n1:ShortTermRecommendation"/>
									</fo:block>
								</fo:table-cell>
							</fo:table-row>
						</xsl:if>
					</xsl:for-each>
				</fo:table-body>
			</fo:table>
		</fo:block>
	</xsl:template>
	<!-- /Recommendations Page Style Definition -->
	<!-- Findings - Affected Items List Style Definition -->
	<xsl:template match="n1:AffectedItems">
		<fo:block color="#111111" font-size="8pt" margin-right="2pt" wrap-option="wrap">
			<fo:list-block provisional-distance-between-starts="7mm" provisional-label-separation="2mm" space-after.optimum="4pt" space-before.optimum="4pt" start-indent="2mm">
				<fo:list-item>
					<fo:list-item-label end-indent="label-end()">
						<fo:block>•</fo:block>
					</fo:list-item-label>
					<fo:list-item-body start-indent="body-start()">
						<fo:block margin-left="10pt">
							<xsl:value-of select="substring(.,0,40)"/>​ <xsl:value-of select="substring(.,40,40)"/>​ <xsl:value-of select="substring(.,80,40)"/>​ <xsl:value-of select="substring(.,120,40)"/>​ <xsl:value-of select="substring(.,160,40)"/>​ <xsl:value-of select="substring(.,200,40)"/>​ <xsl:value-of select="substring(.,240,40)"/>​ <xsl:value-of select="substring(.,280,40)"/>​ <xsl:value-of select="substring(.,320,40)"/>​ <xsl:value-of select="substring(.,360,40)"/>​ <xsl:value-of select="substring(.,400,40)"/>​ </fo:block>
					</fo:list-item-body>
				</fo:list-item>
			</fo:list-block>
		</fo:block>
	</xsl:template>
	<!-- /Findings - Affected Items List Style Definition -->
	<!-- Findings - Comments Style Definition -->
	<xsl:template match="n1:Comments">
		<fo:block color="#111111" font-size="8pt" margin-right="2pt" wrap-option="wrap">
			<xsl:value-of select="."/>
		</fo:block>
	</xsl:template>
	<!-- /Findings - Comments Style Definition -->
	<!-- Findings - Rating Style Definition -->
	<xsl:template match="n1:rating">
		<fo:block>
			<fo:table border-color="black" border-style="solid" border-width="1px" padding="0" space-after.optimum="2pt" space-before.optimum="2pt" table-layout="fixed" width="100%">
				<fo:table-column column-width="80pt"/>
				<fo:table-column/>
				<fo:table-body>
					<fo:table-row>
						<fo:table-cell border-style="solid" display-align="center" padding="5pt" text-align="center">
							<fo:block color="#111111" font-size="10pt">
								<fo:inline font-weight="bold">
									<xsl:value-of select="n1:ratingValue"/>
								</fo:inline>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell border-style="solid" padding="5pt">
							<fo:block color="#111111" font-size="10pt" margin-right="2pt" wrap-option="wrap">
								<xsl:value-of select="n1:ratingComment"/>
							</fo:block>
						</fo:table-cell>
					</fo:table-row>
				</fo:table-body>
			</fo:table>
		</fo:block>
	</xsl:template>
	<!-- /Findings - Rating Style Definition -->
	<!-- Executive Summary - Summary Table Definition -->
	<xsl:template match="n1:summaryTable">
		<fo:block>
			<fo:table border-color="black" border-style="solid" border-width="1px" padding="0" space-after.optimum="2pt" space-before.optimum="2pt" table-layout="fixed" width="160pt">
				<fo:table-column column-width="80pt"/>
				<fo:table-column column-width="80pt"/>
				<fo:table-body>
					<fo:table-row>
						<fo:table-cell border-style="solid" display-align="center" padding="5pt" text-align="center">
							<fo:block color="#111111" font-size="10pt">
								<fo:inline font-weight="bold"> Critical </fo:inline>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell border-style="solid" padding="5pt" text-align="center">
							<fo:block color="#111111" font-size="10pt" margin-right="2pt" wrap-option="wrap">
								<xsl:value-of select="count(/n1:Project/n1:Targets/n1:Target/n1:Findings/n1:Finding[@Impact='Critical'])"/>
							</fo:block>
						</fo:table-cell>
					</fo:table-row>
					<fo:table-row>
						<fo:table-cell border-style="solid" display-align="center" padding="5pt" text-align="center">
							<fo:block color="#111111" font-size="10pt">
								<fo:inline font-weight="bold"> High </fo:inline>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell border-style="solid" padding="5pt" text-align="center">
							<fo:block color="#111111" font-size="10pt" margin-right="2pt" wrap-option="wrap">
								<xsl:value-of select="count(/n1:Project/n1:Targets/n1:Target/n1:Findings/n1:Finding[@Impact='High'])"/>
							</fo:block>
						</fo:table-cell>
					</fo:table-row>
					<fo:table-row>
						<fo:table-cell border-style="solid" display-align="center" padding="5pt" text-align="center">
							<fo:block color="#111111" font-size="10pt">
								<fo:inline font-weight="bold"> Medium </fo:inline>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell border-style="solid" padding="5pt" text-align="center">
							<fo:block color="#111111" font-size="10pt" margin-right="2pt" wrap-option="wrap">
								<xsl:value-of select="count(/n1:Project/n1:Targets/n1:Target/n1:Findings/n1:Finding[@Impact='Medium'])"/>
							</fo:block>
						</fo:table-cell>
					</fo:table-row>
					<fo:table-row>
						<fo:table-cell border-style="solid" display-align="center" padding="5pt" text-align="center">
							<fo:block color="#111111" font-size="10pt">
								<fo:inline font-weight="bold"> Low </fo:inline>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell border-style="solid" padding="5pt" text-align="center">
							<fo:block color="#111111" font-size="10pt" margin-right="2pt" wrap-option="wrap">
								<xsl:value-of select="count(/n1:Project/n1:Targets/n1:Target/n1:Findings/n1:Finding[@Impact='Low'])"/>
							</fo:block>
						</fo:table-cell>
					</fo:table-row>
				</fo:table-body>
			</fo:table>
		</fo:block>
	</xsl:template>
	<!-- Executive Summary - Summary Table Definition -->
	<!-- Findings - Findings Table Top Row Style Definition -->
	<xsl:template name="printTopOfFindingsTable">
		<fo:table-row background-color="#003399" color="#FFFFFF" text-align="left">
			<fo:table-cell border-style="solid" padding="2pt" text-align="left">
				<fo:block font-size="10pt" font-weight="bold">TSA ID</fo:block>
			</fo:table-cell>
			<fo:table-cell border-style="solid" padding="2pt" text-align="left">
				<fo:block font-size="10pt" font-weight="bold">Layer</fo:block>
			</fo:table-cell>
			<fo:table-cell border-style="solid" padding="2pt" text-align="left">
				<fo:block font-size="10pt" font-weight="bold">Category</fo:block>
			</fo:table-cell>
			<fo:table-cell border-style="solid" padding="2pt">
				<fo:block font-size="10pt" font-weight="bold">Finding</fo:block>
			</fo:table-cell>
			<fo:table-cell border-style="solid" padding="2pt">
				<fo:block font-size="10pt" font-weight="bold">Affected Item</fo:block>
			</fo:table-cell>
			<fo:table-cell border-style="solid" padding="2pt">
				<fo:block font-size="10pt" font-weight="bold">Comment /
        Solution</fo:block>
			</fo:table-cell>
			<fo:table-cell border-style="solid" padding="2pt">
				<fo:block font-size="10pt" font-weight="bold">Impact</fo:block>
			</fo:table-cell>
			<fo:table-cell border-style="solid" padding="2pt">
				<fo:block font-size="10pt" font-weight="bold">Probability</fo:block>
			</fo:table-cell>
		</fo:table-row>
	</xsl:template>
	<!-- Findings - Findings Table Top Row Style Definition -->
	<!-- Findings - Scanned Hosts Style Definition-->
	<xsl:template name="showScannedHosts">
		<xsl:param name="hosts"/>
		<fo:block color="#000000" font-size="16pt" font-weight="bold">
			<xsl:attribute name="id">scannedHosts</xsl:attribute>
			2. Scanned Hosts
		</fo:block>
		<fo:block margin-left="0pt">
			<fo:instream-foreign-object>
				<svg:svg xmlns:svg="http://www.w3.org/2000/svg" width="497" height="2">
					<svg:line x1="0" y1="0" x2="497" y2="0" style="stroke:rgb(00,00,00);stroke-width:2"/>
				</svg:svg>
			</fo:instream-foreign-object>
		</fo:block>
		
		<fo:block color="#000000" font-size="11pt" font-weight="bold" space-before="10pt">
			<xsl:attribute name="id">scannedHostsAll</xsl:attribute>2.1 All Hosts
		</fo:block>
		
		<fo:block color="#111111" font-size="10pt" margin-right="2pt" space-after="10pt" wrap-option="wrap" text-align="justify">
			The following hosts were scanned as part of this assessment:
		</fo:block>
		
		<fo:block color="#111111" font-size="10pt" margin-right="2pt" space-after="10pt" wrap-option="wrap" text-align="justify">
			<fo:list-block>
				<xsl:for-each select="$hosts/n1:Target">
					<xsl:variable name="dnsNamesConcat" select="."/>
					<xsl:for-each select="n1:IP">
							<fo:list-item>
								<fo:list-item-label end-indent="label-end()" margin-left="10pt">
									<fo:block> - </fo:block>
								</fo:list-item-label>
								<fo:list-item-body start-indent="body-start()">
									<fo:block>
										<xsl:value-of select="@value"/> <xsl:call-template name="dnsList"> <xsl:with-param name="dnsNames" select="$dnsNamesConcat"/></xsl:call-template>
									</fo:block>
								</fo:list-item-body>
							</fo:list-item>
						</xsl:for-each>
				</xsl:for-each>
			</fo:list-block>
		</fo:block>
		
		<fo:block color="#000000" font-size="11pt" font-weight="bold" space-before="10pt">
			<xsl:attribute name="id">scannedHostsNoFindings</xsl:attribute>2.2 Hosts without Findings
		</fo:block>

		<xsl:if test="count($hosts/n1:Target[count(n1:Findings/n1:Finding[@IncludeInReport='true']) = 0]) > 0">
			<fo:block color="#111111" font-size="10pt" margin-right="2pt" space-after="10pt" wrap-option="wrap" text-align="justify">
				The following hosts were scanned as part of this assessment and were found to be free of security issues:
			</fo:block>
		</xsl:if>
		<xsl:if test="count($hosts/n1:Target[count(n1:Findings/n1:Finding[@IncludeInReport='true']) = 0]) = 0">
			<fo:block color="#111111" font-size="10pt" margin-right="2pt" space-after="10pt" wrap-option="wrap" text-align="justify">
				None of the scanned hosts were found to be free of security issues.
			</fo:block>
		</xsl:if>
		
		<fo:block color="#111111" font-size="10pt" margin-right="2pt" space-after="10pt" wrap-option="wrap" text-align="justify">
			<fo:list-block>
				<xsl:for-each select="$hosts/n1:Target[count(n1:Findings/n1:Finding[@IncludeInReport='true']) = 0]">
					<xsl:variable name="dnsNamesConcat" select="."/>
					<xsl:for-each select="n1:IP">
							<fo:list-item>
								<fo:list-item-label end-indent="label-end()" margin-left="10pt">
									<fo:block> - </fo:block>
								</fo:list-item-label>
								<fo:list-item-body start-indent="body-start()">
									<fo:block>
										<xsl:value-of select="@value"/> <xsl:call-template name="dnsList"> <xsl:with-param name="dnsNames" select="$dnsNamesConcat"/></xsl:call-template>
									</fo:block>
								</fo:list-item-body>
							</fo:list-item>
						</xsl:for-each>
				</xsl:for-each>
			</fo:list-block>
		</fo:block>
		
	</xsl:template>
	<!-- /Findings - Scanned Hosts Style Definition-->
	
	<xsl:template name="dnsList">
		<xsl:param name="dnsNames"/>
		<xsl:if test="count($dnsNames/n1:DnsName)">
			(<xsl:for-each select="$dnsNames/n1:DnsName">
				<xsl:value-of select="@value"/>
				<xsl:if test="position() &lt; count($dnsNames/n1:DnsName)">, </xsl:if>
			</xsl:for-each>)
		</xsl:if>
	</xsl:template>
</xsl:stylesheet>

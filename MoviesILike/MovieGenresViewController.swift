//
//  MovieGenresViewController.swift
//  MoviesILike
//
//  Created by Jesus Fabian on 11/16/16.
//  Copyright © 2016 Jesus Fabian. All rights reserved.
//

import UIKit

class MovieGenresViewController: UIViewController, UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate {

    let applicationDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet var leftArrow: UIImageView!
    
    @IBOutlet var rightArrow: UIImageView!
    
    @IBOutlet var scrollMenu: UIScrollView!
    @IBOutlet var movieTableView: UITableView!
    
    var dict_Movies_Genres = [String: AnyObject]()
    
    var movieGenres = [String]()
    var dataObjectToPass = [String]()
    
    // Other properties (instance variables) and their initializations
    let kScrollMenuHeight: CGFloat = 80.0
    var selectedMovieGenre = ""
    var previousButton = UIButton(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    
    let backgroundColorToUse = UIColor(red: 0.6, green: 0.8, blue: 1.0, alpha: 1.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        movieGenres = applicationDelegate.dict_Movie_Genres.allKeys as! [String]
        
        movieGenres.sort { $0 < $1 }
        
        /**********************
         * Set Background Colors
         **********************/
        
        self.view.backgroundColor = UIColor.white
        leftArrow.backgroundColor = backgroundColorToUse
        rightArrow.backgroundColor = backgroundColorToUse
        scrollMenu.backgroundColor = backgroundColorToUse
        
        /***********************************************************************
         * Instantiate and setup the buttons for the horizontally scrollable menu
         ***********************************************************************/
        
        // Instantiate a mutable array to hold the menu buttons to be created
        var listOfMenuButtons = [UIButton]()
        
        for i in 0 ..< movieGenres.count {
            
            // Instantiate a button to be placed within the horizontally scrollable menu
            let scrollMenuButton = UIButton(type: UIButtonType.custom)
            
            let givenMovieGenre = movieGenres[i]
    
            let movieGenreLogo = UIImage(named: givenMovieGenre)
            
            // Set the button frame at origin at (x, y) = (0, 0) with
            // button width  = auto logo image width + 10 points padding for each side
            // button height = kScrollMenuHeight points
            scrollMenuButton.frame = CGRect(x: 0.0, y: 0.0, width: movieGenreLogo!.size.width + 20.0, height: kScrollMenuHeight)
            
            // Set the button image to be the auto maker's logo
            scrollMenuButton.setImage(movieGenreLogo, for: UIControlState())
            
            // Obtain the title (i.e., auto manufacturer name) to be displayed on the button
            let buttonTitle = givenMovieGenre
            
            // The button width and height in points will depend on its font style and size
            let buttonTitleFont = UIFont(name: "Helvetica", size: 14.0)
            
            // Set the font of the button title label text
            scrollMenuButton.titleLabel?.font = buttonTitleFont
            
            // Compute the size of the button title in points
            let buttonTitleSize: CGSize = (buttonTitle as NSString).size(attributes: [NSFontAttributeName:buttonTitleFont!])
            
            let titleTextWidth = buttonTitleSize.width
            let logoImageWidth = movieGenreLogo!.size.width
            
            var buttonWidth: CGFloat = 0.0
            
            // Set the button width to be the largest width + 20 pixels of padding
            if titleTextWidth > logoImageWidth {
                buttonWidth = titleTextWidth + 20.0
            } else {
                buttonWidth = logoImageWidth + 20.0
            }
            
            // Set the button frame with width=buttonWidth height=kScrollMenuHeight points with origin at (x, y) = (0, 0)
            scrollMenuButton.frame = CGRect(x: 0.0, y: 0.0, width: buttonWidth, height: kScrollMenuHeight)
            
            // Set the button title to the automobile manufacturer's name
            scrollMenuButton.setTitle(givenMovieGenre, for: UIControlState())
            
            // Set the button title color to black when the button is not selected
            scrollMenuButton.setTitleColor(UIColor.black, for: UIControlState())
            
            // Set the button title color to red when the button is selected
            scrollMenuButton.setTitleColor(UIColor.red, for: UIControlState.selected)
            
            // Specify the Inset values for top, left, bottom, and right edges for the title
            scrollMenuButton.titleEdgeInsets = UIEdgeInsetsMake(0.0, -movieGenreLogo!.size.width, -(movieGenreLogo!.size.height + 5), 0.0)
            
            // Specify the Inset values for top, left, bottom, and right edges for the auto logo image
            scrollMenuButton.imageEdgeInsets = UIEdgeInsetsMake(-(buttonTitleSize.height + 5), 0.0, 0.0, -buttonTitleSize.width)
            
            // Set the button to invoke the buttonPressed: method when the user taps it
            scrollMenuButton.addTarget(self, action: #selector(MovieGenresViewController.buttonPressed(_:)), for: .touchUpInside)
            
            // Add the constructed button to the list of buttons
            listOfMenuButtons.append(scrollMenuButton)
        }
        
        /*********************************************************************************************
         * Compute the sumOfButtonWidths = sum of the widths of all buttons to be displayed in the menu
         *********************************************************************************************/
        
        var sumOfButtonWidths: CGFloat = 0.0
        
        for j in 0 ..< listOfMenuButtons.count {
            
            // Obtain the obj ref to the jth button in the listOfMenuButtons array
            let button: UIButton = listOfMenuButtons[j]
            
            // Set the button's frame to buttonRect
            var buttonRect: CGRect = button.frame
            
            // Set the buttonRect's x coordinate value to sumOfButtonWidths
            buttonRect.origin.x = sumOfButtonWidths
            
            // Set the button's frame to the newly specified buttonRect
            button.frame = buttonRect
            
            // Add the button to the horizontally scrollable menu
            scrollMenu.addSubview(button)
            
            // Add the width of the button to the total width
            sumOfButtonWidths += button.frame.size.width
        }
        
        // Horizontally scrollable menu's content width size = the sum of the widths of all of the buttons
        // Horizontally scrollable menu's content height size = kScrollMenuHeight points
        scrollMenu.contentSize = CGSize(width: sumOfButtonWidths, height: kScrollMenuHeight)
        
        /*******************************************************
         * Select and show the default auto maker upon app launch
         *******************************************************/
        
        // Hide left arrow
        leftArrow.isHidden = true
        
        // The first auto maker on the list is the default one to display
        let defaultButton: UIButton = listOfMenuButtons[0]
        
        // Indicate that the button is selected
        defaultButton.isSelected = true
        
        previousButton = defaultButton
        selectedMovieGenre = movieGenres[0]
        
        movieTableView.reloadData()
    }
    
    /*
     -----------------------------------
     MARK: - Method to Handle Button Tap
     -----------------------------------
     */
    // This method is invoked when the user taps a button in the horizontally scrollable menu
    func buttonPressed(_ sender: UIButton) {
        
        let selectedButton: UIButton = sender
        
        // Indicate that the button is selected
        selectedButton.isSelected = true
        
        if previousButton != selectedButton {
            // Selecting the selected button again should not change its title color
            previousButton.isSelected = false
        }
        
        previousButton = selectedButton
        
        selectedMovieGenre = selectedButton.title(for: UIControlState())!
        
        // Redisplay the table view object's content for the selected auto maker
        movieTableView.reloadData()
    }
    
    /*
     -----------------------------------
     MARK: - Scroll View Delegate Method
     -----------------------------------
     */
    
    // Tells the delegate when the user scrolls the content view within the receiver
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        // The autoTableView object scrolling also invokes this method, in the case of which no action
        // should be taken since this method is created to handle only the scrollMenu object's scrolling.
        if scrollView == movieTableView {
            return
        }
        
        /*
         Content        = concatenated list of buttons
         Content Width  = sum of all button widths, sumOfButtonWidths
         Content Height = kScrollMenuHeight points
         Origin         = (x, y) values of the bottom left corner of the scroll view or content
         Sx             = Scroll View's origin x value
         Cx             = Content's origin x value
         contentOffset  = Sx - Cx
         
         Interpretation of the Arrows:
         
         IF scrolled all the way to the RIGHT THEN show only RIGHT arrow: indicating that the data (content) is
         on the right hand side and therefore, the user must *** scroll to the left *** to see the content.
         
         IF scrolled all the way to the LEFT THEN show only LEFT arrow: indicating that the data (content) is
         on the left hand side and therefore, the user must *** scroll to the right *** to see the content.
         
         5 pixels used as padding
         */
        if scrollView.contentOffset.x <= 5 {
            // Scrolling is done all the way to the RIGHT
            leftArrow.isHidden   = true      // Hide left arrow
            rightArrow.isHidden  = false     // Show right arrow
        }
        else if scrollView.contentOffset.x >= (scrollView.contentSize.width - scrollView.frame.size.width) - 5 {
            // Scrolling is done all the way to the LEFT
            leftArrow.isHidden   = false     // Show left arrow
            rightArrow.isHidden  = true      // Hide right arrow
        }
        else {
            // Scrolling is in between. Scrolling can be done in either direction.
            leftArrow.isHidden   = false     // Show left arrow
            rightArrow.isHidden  = false     // Show right arrow
        }
    }
    
    /*
     --------------------------------------
     MARK: - Table View Data Source Methods
     --------------------------------------
     */
    
    // Asks the data source to return the number of rows in a section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let moviesForSelectedGenre: NSDictionary = applicationDelegate.dict_Movie_Genres[selectedMovieGenre] as! NSDictionary
        return moviesForSelectedGenre.count
    }
    
    // Asks the data source to return a cell to insert in a particular table view location
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Identify the row number
        let rowNumber = (indexPath as NSIndexPath).row
        
        // Obtain the array of auto model names for the selected auto maker
        let moviesForSelectedGenre: NSDictionary = applicationDelegate.dict_Movie_Genres[selectedMovieGenre] as! NSDictionary
        
        // Obtain the object reference of a reusable table view cell object instantiated under the identifier
        // AutoTableViewCell, which was specified in the storyboard
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "MovieGenreTablewViewCell") as UITableViewCell!
        let strRowNum = String(rowNumber+1)
        let arrMovie = moviesForSelectedGenre[strRowNum] as! [String]
        // Set the label text of the cell to be the auto model name.
        // We add 1 to row number because the first item is the name of the logo image file.
        cell.textLabel!.text = arrMovie[0]
        cell.detailTextLabel!.text = arrMovie[1]
        
        // Add the manufacturer's logo for each auto model name listed in the table view
        cell.imageView!.image = UIImage(named: arrMovie[3])
        
        return cell
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
     ----------------------------------
     MARK: - Table View Delegate Method
     ----------------------------------
     */
    
    // This method is invoked when the user taps a table view row
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Identify the row number
        let rowNumber = (indexPath as NSIndexPath).row
        
        // Obtain the array of model names for the selected auto maker
        let moviesForSelectedGenre: NSDictionary = applicationDelegate.dict_Movie_Genres[selectedMovieGenre] as! NSDictionary
        
        let strRowNum = String(rowNumber + 1)
        // Convert the array to be a Swift array
        let selectedMovieArray = moviesForSelectedGenre[strRowNum] as! [String]

        dataObjectToPass.append(selectedMovieArray[0])
        dataObjectToPass.append(selectedMovieArray[2])
        print(dataObjectToPass)
        
        performSegue(withIdentifier: "youtubeWeb", sender: self)

        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "youtubeWeb" {
            let youtubeWebView: GenreTrailerViewController = segue.destination as! GenreTrailerViewController
            youtubeWebView.dataObjectPassed = dataObjectToPass
        }
    }
    

}
